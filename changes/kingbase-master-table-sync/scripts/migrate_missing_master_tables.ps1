param(
    [string]$SourceHost = "192.168.0.77",
    [int]$SourcePort = 15432,
    [string]$SourceDatabase = "building_supplies_supervision",
    [string]$SourceUser = "postgres",
    [string]$SourcePassword = "zAIgc4xm5Bcax*os",

    [string]$TargetHost = "192.168.0.67",
    [int]$TargetPort = 54323,
    [string]$TargetDatabase = "building_supplies_supervision",
    [string]$TargetUser = "system",
    [string]$TargetPassword = "AJxm9WtI4r",

    [string]$Schema = "master",
    [string]$ArtifactRoot = "E:\construction-material\backups"
)

$ErrorActionPreference = "Stop"

$pgBin = "C:\Program Files\PostgreSQL\18\bin"
$pgDump = Join-Path $pgBin "pg_dump.exe"
$psql = Join-Path $pgBin "psql.exe"

$tables = @(
    "base_message",
    "base_message_receive",
    "base_message_template",
    "sys_dict_type",
    "sys_logininfor",
    "t_product_relation"
)

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$artifactDir = Join-Path $ArtifactRoot "kingbase-master-table-sync_$timestamp"
$schemaDir = Join-Path $artifactDir "schema"
$dataDir = Join-Path $artifactDir "data"
$logDir = Join-Path $artifactDir "logs"
$summaryFile = Join-Path $artifactDir "summary.txt"

New-Item -ItemType Directory -Force -Path $artifactDir, $schemaDir, $dataDir, $logDir | Out-Null

function Invoke-DbCommand {
    param(
        [string]$DbHost,
        [int]$DbPort,
        [string]$DbDatabase,
        [string]$DbUser,
        [string]$DbPassword,
        [string]$Sql,
        [string]$OutputFile
    )

    $env:PGPASSWORD = $DbPassword
    if ($OutputFile) {
        & $psql -v ON_ERROR_STOP=1 -h $DbHost -p $DbPort -U $DbUser -d $DbDatabase -P pager=off -c $Sql 2>&1 |
            Tee-Object -FilePath $OutputFile
    } else {
        & $psql -v ON_ERROR_STOP=1 -h $DbHost -p $DbPort -U $DbUser -d $DbDatabase -P pager=off -c $Sql
    }
    if ($LASTEXITCODE -ne 0) {
        throw "psql execution failed against ${DbHost}:${DbPort}/${DbDatabase}"
    }
}

function Invoke-DbFile {
    param(
        [string]$DbHost,
        [int]$DbPort,
        [string]$DbDatabase,
        [string]$DbUser,
        [string]$DbPassword,
        [string]$FilePath,
        [string]$OutputFile
    )

    $env:PGPASSWORD = $DbPassword
    if ($OutputFile) {
        & $psql -v ON_ERROR_STOP=1 -h $DbHost -p $DbPort -U $DbUser -d $DbDatabase -f $FilePath 2>&1 |
            Tee-Object -FilePath $OutputFile
    } else {
        & $psql -v ON_ERROR_STOP=1 -h $DbHost -p $DbPort -U $DbUser -d $DbDatabase -f $FilePath
    }
    if ($LASTEXITCODE -ne 0) {
        throw "psql file execution failed for ${FilePath}"
    }
}

function Get-SingleValue {
    param(
        [string]$DbHost,
        [int]$DbPort,
        [string]$DbDatabase,
        [string]$DbUser,
        [string]$DbPassword,
        [string]$Sql
    )

    $env:PGPASSWORD = $DbPassword
    $result = & $psql -v ON_ERROR_STOP=1 -h $DbHost -p $DbPort -U $DbUser -d $DbDatabase -At -P pager=off -c $Sql
    if ($LASTEXITCODE -ne 0) {
        throw "psql scalar query failed"
    }
    return ($result | Select-Object -Last 1).Trim()
}

function Export-TableDump {
    param(
        [string]$TableName,
        [string]$Mode,
        [string]$OutputFile
    )

    $env:PGPASSWORD = $SourcePassword
    $modeArg = if ($Mode -eq "schema") { "--schema-only" } else { "--data-only" }
    & $pgDump -h $SourceHost -p $SourcePort -U $SourceUser -d $SourceDatabase `
        -n $Schema -t "$Schema.$TableName" `
        --no-owner --no-privileges `
        $modeArg `
        -f $OutputFile

    if ($LASTEXITCODE -ne 0) {
        throw "pg_dump $Mode failed for $TableName"
    }
}

function Sanitize-DumpFile {
    param(
        [string]$FilePath
    )

    $content = Get-Content -Path $FilePath -Raw -Encoding UTF8
    $sanitized = $content `
        -replace "SET transaction_timeout = 0;\r?\n", ""
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($FilePath, $sanitized, $utf8NoBom)
}

$functionSqlPath = Join-Path $artifactDir "001_create_generate_snowflake_id.sql"
@'
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_proc p
        JOIN pg_namespace n ON p.pronamespace = n.oid
        WHERE n.nspname = 'public'
          AND p.proname = 'generate_snowflake_id'
    ) THEN
        EXECUTE $fn$
            CREATE OR REPLACE FUNCTION public.generate_snowflake_id()
            RETURNS bigint
            LANGUAGE plpgsql
            AS $function$
            DECLARE
                start_ts BIGINT := 1609459200000;
                machine_id INT := 1;
                seq INT := 0;
                curr_ts BIGINT;
                snowflake_id BIGINT;
            BEGIN
                SELECT EXTRACT(EPOCH FROM NOW()) * 1000 INTO curr_ts;
                curr_ts := curr_ts - start_ts;
                snowflake_id := (curr_ts << 17) | (machine_id << 12) | seq;
                seq := seq + 1;
                IF seq > 4095 THEN
                    seq := 0;
                    PERFORM pg_sleep(0.001);
                END IF;
                RETURN snowflake_id;
            END;
            $function$;
        $fn$;
    END IF;
END
$$;
'@ | Set-Content -Path $functionSqlPath -Encoding UTF8

"Migration started at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz')" | Set-Content -Path $summaryFile -Encoding UTF8
"Artifacts: $artifactDir" | Add-Content -Path $summaryFile -Encoding UTF8

Invoke-DbFile -DbHost $TargetHost -DbPort $TargetPort -DbDatabase $TargetDatabase -DbUser $TargetUser -DbPassword $TargetPassword `
    -FilePath $functionSqlPath -OutputFile (Join-Path $logDir "001_create_generate_snowflake_id.log.txt")

foreach ($table in $tables) {
    $targetTableExists = Get-SingleValue -DbHost $TargetHost -DbPort $TargetPort -DbDatabase $TargetDatabase -DbUser $TargetUser -DbPassword $TargetPassword `
        -Sql "select count(*) from information_schema.tables where table_schema='$Schema' and table_name='$table';"
    $schemaFile = Join-Path $schemaDir "$table.schema.sql"
    $dataFile = Join-Path $dataDir "$table.data.sql"

    Export-TableDump -TableName $table -Mode "schema" -OutputFile $schemaFile
    Export-TableDump -TableName $table -Mode "data" -OutputFile $dataFile
    Sanitize-DumpFile -FilePath $schemaFile
    Sanitize-DumpFile -FilePath $dataFile

    if ($targetTableExists -ne "0") {
        Invoke-DbCommand -DbHost $TargetHost -DbPort $TargetPort -DbDatabase $TargetDatabase -DbUser $TargetUser -DbPassword $TargetPassword `
            -Sql "DROP TABLE $Schema.$table CASCADE;" `
            -OutputFile (Join-Path $logDir "$table.drop.log.txt")
    } else {
        "Skip drop for missing table: $Schema.$table" | Add-Content -Path $summaryFile -Encoding UTF8
    }

    Invoke-DbFile -DbHost $TargetHost -DbPort $TargetPort -DbDatabase $TargetDatabase -DbUser $TargetUser -DbPassword $TargetPassword `
        -FilePath $schemaFile -OutputFile (Join-Path $logDir "$table.schema.apply.log.txt")

    Invoke-DbFile -DbHost $TargetHost -DbPort $TargetPort -DbDatabase $TargetDatabase -DbUser $TargetUser -DbPassword $TargetPassword `
        -FilePath $dataFile -OutputFile (Join-Path $logDir "$table.data.apply.log.txt")

    $sourceCount = Get-SingleValue -DbHost $SourceHost -DbPort $SourcePort -DbDatabase $SourceDatabase -DbUser $SourceUser -DbPassword $SourcePassword `
        -Sql "select count(*) from $Schema.$table;"
    $targetCount = Get-SingleValue -DbHost $TargetHost -DbPort $TargetPort -DbDatabase $TargetDatabase -DbUser $TargetUser -DbPassword $TargetPassword `
        -Sql "select count(*) from $Schema.$table;"

    "[$table] source=$sourceCount target=$targetCount" | Add-Content -Path $summaryFile -Encoding UTF8

    if ($sourceCount -ne $targetCount) {
        throw "Row count mismatch for ${table}: source=${sourceCount} target=${targetCount}"
    }
}

"Migration completed at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz')" | Add-Content -Path $summaryFile -Encoding UTF8
Write-Output "Migration completed successfully."
Write-Output "Artifacts saved to: $artifactDir"
