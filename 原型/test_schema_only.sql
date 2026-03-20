--
-- PostgreSQL database dump
--

\restrict 5szZlKjsafTztVKL3CRuGqS5XVAR7iLwSCdkig9hZJq4sFcrUHxhc991t3UMnFd

-- Dumped from database version 15.3 (Debian 15.3-1.pgdg120+1)
-- Dumped by pg_dump version 18.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: test; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA test;


ALTER SCHEMA test OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Sheet1$; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test."Sheet1$" (
    "F1" character varying(255),
    "F2" character varying(255),
    "F3" character varying(255),
    "F4" character varying(255)
);


ALTER TABLE test."Sheet1$" OWNER TO postgres;

--
-- Name: base_appdata; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.base_appdata (
    "F_Id" character varying(50) NOT NULL,
    "F_ObjectType" character varying(50),
    "F_ObjectId" character varying(50),
    "F_ObjectData" text,
    "F_Description" text,
    "F_EnabledMark" integer,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50),
    "F_DeleteMark" integer
);


ALTER TABLE test.base_appdata OWNER TO postgres;

--
-- Name: base_authorize; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.base_authorize (
    "F_Id" character varying(50) NOT NULL,
    "F_ItemType" character varying(50),
    "F_ItemId" character varying(50),
    "F_ObjectType" character varying(50),
    "F_ObjectId" character varying(50),
    "F_SortCode" bigint,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50)
);


ALTER TABLE test.base_authorize OWNER TO postgres;

--
-- Name: base_billrule; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.base_billrule (
    "F_Id" character varying(50) NOT NULL,
    "F_FullName" character varying(50),
    "F_EnCode" character varying(50),
    "F_Prefix" character varying(50),
    "F_DateFormat" character varying(50),
    "F_Digit" integer,
    "F_StartNumber" character varying(50),
    "F_Example" character varying(100),
    "F_ThisNumber" integer,
    "F_OutputNumber" character varying(100),
    "F_Description" text,
    "F_SortCode" bigint,
    "F_EnabledMark" integer,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50),
    "F_DeleteMark" integer
);


ALTER TABLE test.base_billrule OWNER TO postgres;

--
-- Name: base_comfields; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.base_comfields (
    "F_Id" character varying(50) NOT NULL,
    "F_Description" text,
    "F_SortCode" bigint,
    "F_EnabledMark" integer,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteMark" integer,
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50),
    "F_FieldName" character varying(50),
    "F_DataType" character varying(50),
    "F_DataLength" character varying(50),
    "F_AllowNull" integer,
    "F_Field" character varying(50)
);


ALTER TABLE test.base_comfields OWNER TO postgres;

--
-- Name: base_datainterface; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.base_datainterface (
    "F_Id" character varying(50) NOT NULL,
    "F_CategoryId" character varying(50) NOT NULL,
    "F_FullName" character varying(50) NOT NULL,
    "F_Path" character varying(200),
    "F_RequestMethod" character varying(50) NOT NULL,
    "F_ResponseType" character varying(50) NOT NULL,
    "F_Query" text NOT NULL,
    "F_RequestParameters" text,
    "F_ResponseParameters" text,
    "F_EnCode" character varying(50),
    "F_SortCode" bigint NOT NULL,
    "F_EnabledMark" integer NOT NULL,
    "F_Description" text,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50) NOT NULL,
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteMark" integer,
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50),
    "F_DbLinkId" character varying(100) NOT NULL,
    "F_DataType" integer,
    "F_CheckType" integer,
    "F_RequestHeaders" character varying(200),
    "F_DataProcessing" text
);


ALTER TABLE test.base_datainterface OWNER TO postgres;

--
-- Name: base_datainterfacelog; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.base_datainterfacelog (
    "F_Id" character varying(50) NOT NULL,
    "F_InvokId" character varying(50) NOT NULL,
    "F_InvokTime" timestamp without time zone,
    "F_UserId" character varying(50),
    "F_InvokIp" character varying(255),
    "F_InvokDevice" character varying(255),
    "F_InvokWasteTime" integer,
    "F_InvokType" character varying(50)
);


ALTER TABLE test.base_datainterfacelog OWNER TO postgres;

--
-- Name: base_dbbackup; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.base_dbbackup (
    "F_Id" character varying(50) NOT NULL,
    "F_BackupDbName" character varying(50),
    "F_BackupTime" timestamp without time zone,
    "F_FileName" character varying(50),
    "F_FileSize" character varying(50),
    "F_FilePath" text,
    "F_Description" text,
    "F_SortCode" bigint,
    "F_EnabledMark" integer,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteMark" integer,
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50)
);


ALTER TABLE test.base_dbbackup OWNER TO postgres;

--
-- Name: base_dblink; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.base_dblink (
    "F_Id" character varying(50) NOT NULL,
    "F_FullName" character varying(50),
    "F_DbType" character varying(50),
    "F_Host" character varying(50),
    "F_Port" integer,
    "F_UserName" character varying(50),
    "F_Password" character varying(50),
    "F_ServiceName" character varying(50),
    "F_Description" text,
    "F_SortCode" bigint,
    "F_EnabledMark" integer,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteMark" integer,
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50),
    "F_DbSchema" character varying(50),
    "F_TableSpace" character varying(50),
    "F_OracleParam" character varying(255)
);


ALTER TABLE test.base_dblink OWNER TO postgres;

--
-- Name: base_dictionarydata; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.base_dictionarydata (
    "F_Id" character varying(50) NOT NULL,
    "F_ParentId" character varying(50),
    "F_FullName" character varying(500),
    "F_EnCode" character varying(50),
    "F_SimpleSpelling" text,
    "F_IsDefault" integer,
    "F_Description" text,
    "F_SortCode" bigint,
    "F_EnabledMark" integer,
    "F_IsTitle" integer,
    "F_IsCustom" integer,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteMark" integer,
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50),
    "F_DictionaryTypeId" character varying(50),
    "F_ZjcCode" character varying(50)
);


ALTER TABLE test.base_dictionarydata OWNER TO postgres;

--
-- Name: base_dictionarytype; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.base_dictionarytype (
    "F_Id" character varying(50) NOT NULL,
    "F_ParentId" character varying(50),
    "F_FullName" character varying(50),
    "F_EnCode" character varying(50),
    "F_IsTree" integer,
    "F_Description" text,
    "F_SortCode" bigint,
    "F_EnabledMark" integer,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteMark" integer,
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50)
);


ALTER TABLE test.base_dictionarytype OWNER TO postgres;

--
-- Name: base_imcontent; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.base_imcontent (
    "F_Id" character varying(50) NOT NULL,
    "F_SendUserId" character varying(50),
    "F_SendTime" timestamp without time zone,
    "F_ReceiveUserId" character varying(50),
    "F_ReceiveTime" timestamp without time zone,
    "F_Content" text,
    "F_ContentType" character varying(50),
    "F_State" integer
);


ALTER TABLE test.base_imcontent OWNER TO postgres;

--
-- Name: base_imreply; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.base_imreply (
    "F_Id" character varying(50) NOT NULL,
    "F_UserId" character varying(50),
    "F_ReceiveUserId" character varying(50),
    "F_ReceiveTime" timestamp without time zone
);


ALTER TABLE test.base_imreply OWNER TO postgres;

--
-- Name: base_message; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.base_message (
    "F_Id" character varying(50) NOT NULL,
    "F_Type" integer,
    "F_Title" character varying(200),
    "F_BodyText" text,
    "F_PriorityLevel" integer,
    "F_ToUserIds" text,
    "F_IsRead" integer,
    "F_Description" text,
    "F_SortCode" bigint,
    "F_EnabledMark" integer,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteMark" integer,
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50)
);


ALTER TABLE test.base_message OWNER TO postgres;

--
-- Name: base_message_template; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.base_message_template (
    "F_Id" character varying(50) NOT NULL,
    "F_Category" character varying(50),
    "F_FullName" character varying(50),
    "F_Title" character varying(200),
    "F_IsStationLetter" integer,
    "F_IsEmail" integer,
    "F_IsWeCom" integer,
    "F_IsDingTalk" integer,
    "F_IsSMS" integer,
    "F_SmsId" character varying(50),
    "F_TemplateJson" text,
    "F_Content" text,
    "F_EnabledMark" integer,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteMark" integer,
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50)
);


ALTER TABLE test.base_message_template OWNER TO postgres;

--
-- Name: base_messagereceive; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.base_messagereceive (
    "F_Id" character varying(50) NOT NULL,
    "F_Title" character varying(50),
    "F_Content" character varying(300),
    "F_Type" integer,
    "F_SendUser" character varying(50),
    "F_MessageId" character varying(50),
    "F_UserId" character varying(50),
    "F_IsRead" integer,
    "F_ReadTime" timestamp without time zone,
    "F_ReadCount" integer,
    "F_CreatorTime" timestamp without time zone
);


ALTER TABLE test.base_messagereceive OWNER TO postgres;

--
-- Name: TABLE base_messagereceive; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON TABLE test.base_messagereceive IS '消息接收';


--
-- Name: COLUMN base_messagereceive."F_Id"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_messagereceive."F_Id" IS '自然主键';


--
-- Name: COLUMN base_messagereceive."F_MessageId"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_messagereceive."F_MessageId" IS '消息主键';


--
-- Name: COLUMN base_messagereceive."F_UserId"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_messagereceive."F_UserId" IS '用户主键';


--
-- Name: COLUMN base_messagereceive."F_IsRead"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_messagereceive."F_IsRead" IS '是否阅读';


--
-- Name: COLUMN base_messagereceive."F_ReadTime"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_messagereceive."F_ReadTime" IS '阅读时间';


--
-- Name: COLUMN base_messagereceive."F_ReadCount"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_messagereceive."F_ReadCount" IS '阅读次数';


--
-- Name: base_module; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.base_module (
    "F_Id" character varying(50) NOT NULL,
    "F_ParentId" character varying(50),
    "F_Type" integer,
    "F_FullName" character varying(50),
    "F_EnCode" character varying(50),
    "F_UrlAddress" text,
    "F_IsButtonAuthorize" integer,
    "F_IsColumnAuthorize" integer,
    "F_IsDataAuthorize" integer,
    "F_PropertyJson" text,
    "F_Description" text,
    "F_SortCode" bigint,
    "F_EnabledMark" integer,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteMark" integer,
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50),
    "F_LinkTarget" character varying(50),
    "F_Category" character varying(50),
    "F_Icon" character varying(50),
    "F_IsFormAuthorize" integer
);


ALTER TABLE test.base_module OWNER TO postgres;

--
-- Name: base_modulebutton; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.base_modulebutton (
    "F_Id" character varying(50) NOT NULL,
    "F_ParentId" character varying(50),
    "F_FullName" character varying(50),
    "F_EnCode" character varying(50),
    "F_Icon" character varying(50),
    "F_UrlAddress" text,
    "F_PropertyJson" text,
    "F_Description" text,
    "F_SortCode" bigint,
    "F_EnabledMark" integer,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteMark" integer,
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50),
    "F_ModuleId" character varying(50)
);


ALTER TABLE test.base_modulebutton OWNER TO postgres;

--
-- Name: base_modulecolumn; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.base_modulecolumn (
    "F_Id" character varying(50) NOT NULL,
    "F_ParentId" character varying(50),
    "F_FullName" character varying(200),
    "F_EnCode" character varying(200),
    "F_BindTable" character varying(50),
    "F_BindTableName" character varying(50),
    "F_PropertyJson" text,
    "F_Description" text,
    "F_SortCode" bigint,
    "F_EnabledMark" integer,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteMark" integer,
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50),
    "F_ModuleId" character varying(50)
);


ALTER TABLE test.base_modulecolumn OWNER TO postgres;

--
-- Name: base_moduledataauthorize; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.base_moduledataauthorize (
    "F_Id" character varying(50) NOT NULL,
    "F_FullName" character varying(50),
    "F_EnCode" character varying(50),
    "F_Type" character varying(50),
    "F_ConditionSymbol" text,
    "F_ConditionSymbolJson" text,
    "F_ConditionText" character varying(50),
    "F_PropertyJson" text,
    "F_Description" text,
    "F_SortCode" bigint,
    "F_EnabledMark" integer,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteMark" integer,
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50),
    "F_ModuleId" character varying(50)
);


ALTER TABLE test.base_moduledataauthorize OWNER TO postgres;

--
-- Name: base_moduledataauthorizescheme; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.base_moduledataauthorizescheme (
    "F_Id" character varying(50) NOT NULL,
    "F_EnCode" character varying(50),
    "F_FullName" character varying(100),
    "F_ConditionJson" text,
    "F_ConditionText" text,
    "F_Description" text,
    "F_SortCode" bigint,
    "F_EnabledMark" integer,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteMark" integer,
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50),
    "F_ModuleId" character varying(50)
);


ALTER TABLE test.base_moduledataauthorizescheme OWNER TO postgres;

--
-- Name: base_moduleform; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.base_moduleform (
    "F_Id" character varying(50) NOT NULL,
    "F_ParentId" character varying(50),
    "F_FullName" character varying(200),
    "F_EnCode" character varying(200),
    "F_PropertyJson" text,
    "F_Description" text,
    "F_SortCode" bigint,
    "F_EnabledMark" integer,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteMark" integer,
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50),
    "F_ModuleId" character varying(50)
);


ALTER TABLE test.base_moduleform OWNER TO postgres;

--
-- Name: base_organize; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.base_organize (
    "F_Id" character varying(50) NOT NULL,
    "F_ParentId" character varying(50),
    "F_Category" character varying(50),
    "F_EnCode" character varying(50),
    "F_FullName" character varying(500),
    "F_ManagerId" character varying(50),
    "F_PropertyJson" text,
    "F_Description" text,
    "F_SortCode" bigint,
    "F_EnabledMark" integer,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteMark" integer,
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50),
    "F_OrganizeIdTree" text
);


ALTER TABLE test.base_organize OWNER TO postgres;

--
-- Name: base_organizeadministrator; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.base_organizeadministrator (
    "F_Id" character varying(50) NOT NULL,
    "F_UserId" text,
    "F_OrganizeId" character varying(50),
    "F_OrganizeType" character varying(50),
    "F_ThisLayerAdd" integer,
    "F_ThisLayerEdit" integer,
    "F_ThisLayerDelete" integer,
    "F_SubLayerAdd" integer,
    "F_SubLayerEdit" integer,
    "F_SubLayerDelete" integer,
    "F_Description" text,
    "F_SortCode" bigint,
    "F_EnabledMark" integer,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteMark" integer,
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50)
);


ALTER TABLE test.base_organizeadministrator OWNER TO postgres;

--
-- Name: base_portal; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.base_portal (
    "F_Id" character varying(50) NOT NULL,
    "F_Description" text,
    "F_SortCode" bigint,
    "F_EnabledMark" integer,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteMark" integer,
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50),
    "F_FullName" character varying(100),
    "F_EnCode" character varying(50),
    "F_Category" character varying(50),
    "F_FormData" text
);


ALTER TABLE test.base_portal OWNER TO postgres;

--
-- Name: base_position; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.base_position (
    "F_Id" character varying(50) NOT NULL,
    "F_FullName" character varying(50),
    "F_EnCode" character varying(50),
    "F_Type" character varying(50),
    "F_PropertyJson" text,
    "F_Description" text,
    "F_SortCode" bigint,
    "F_EnabledMark" integer,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteMark" integer,
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50),
    "F_OrganizeId" character varying(50)
);


ALTER TABLE test.base_position OWNER TO postgres;

--
-- Name: base_printdev; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.base_printdev (
    "F_Id" character varying(50) NOT NULL,
    "F_FullName" character varying(50),
    "F_Encode" character varying(50),
    "F_Category" character varying(50),
    "F_Type" integer,
    "F_Description" character varying(50),
    "F_SortCode" bigint,
    "F_EnabledMark" integer,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteMark" integer,
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50),
    "F_DbLinkId" character varying(50),
    "F_SqlTemplate" text,
    "F_LeftFields" text,
    "F_PrintTemplate" text
);


ALTER TABLE test.base_printdev OWNER TO postgres;

--
-- Name: base_province; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.base_province (
    "F_Id" character varying(50) NOT NULL,
    "F_ParentId" character varying(50),
    "F_EnCode" character varying(50),
    "F_FullName" character varying(50),
    "F_QuickQuery" character varying(50),
    "F_Type" character varying(50),
    "F_Description" text,
    "F_SortCode" bigint,
    "F_EnabledMark" integer,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteMark" integer,
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50)
);


ALTER TABLE test.base_province OWNER TO postgres;

--
-- Name: base_timetasklog; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.base_timetasklog (
    "F_Id" character varying(50) NOT NULL,
    "F_TaskId" character varying(50),
    "F_RunTime" timestamp without time zone,
    "F_RunResult" integer,
    "F_Description" text
);


ALTER TABLE test.base_timetasklog OWNER TO postgres;

--
-- Name: base_user; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.base_user (
    "F_Id" character varying(50) NOT NULL,
    "F_Account" character varying(500),
    "F_RealName" character varying(50),
    "F_QuickQuery" character varying(500),
    "F_NickName" character varying(50),
    "F_HeadIcon" text,
    "F_Gender" integer,
    "F_Birthday" timestamp without time zone,
    "F_MobilePhone" character varying(20),
    "F_TelePhone" character varying(20),
    "F_Landline" character varying(50),
    "F_Email" character varying(50),
    "F_Nation" character varying(50),
    "F_NativePlace" character varying(50),
    "F_EntryDate" timestamp without time zone,
    "F_CertificatesType" character varying(50),
    "F_CertificatesNumber" character varying(50),
    "F_Education" character varying(50),
    "F_UrgentContacts" character varying(50),
    "F_UrgentTelePhone" character varying(50),
    "F_PostalAddress" text,
    "F_Signature" text,
    "F_Password" character varying(50),
    "F_Secretkey" character varying(50),
    "F_FirstLogTime" timestamp without time zone,
    "F_FirstLogIP" character varying(50),
    "F_PrevLogTime" timestamp without time zone,
    "F_PrevLogIP" character varying(50),
    "F_LastLogTime" timestamp without time zone,
    "F_LastLogIP" character varying(50),
    "F_LogSuccessCount" integer,
    "F_LogErrorCount" integer,
    "F_ChangePasswordDate" timestamp without time zone,
    "F_Language" character varying(50),
    "F_Theme" character varying(50),
    "F_CommonMenu" text,
    "F_IsAdministrator" integer,
    "F_PropertyJson" text,
    "F_Description" text,
    "F_SortCode" bigint,
    "F_EnabledMark" integer,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50),
    "F_DeleteMark" integer,
    "F_ManagerId" character varying(50),
    "F_OrganizeId" text,
    "F_PositionId" text,
    "F_RoleId" text,
    "F_PortalId" character varying(50),
    "F_LockMark" integer,
    "F_UnLockTime" timestamp without time zone
);


ALTER TABLE test.base_user OWNER TO postgres;

--
-- Name: TABLE base_user; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON TABLE test.base_user IS '用户信息';


--
-- Name: COLUMN base_user."F_Id"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_Id" IS '自然主键';


--
-- Name: COLUMN base_user."F_Account"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_Account" IS '账户';


--
-- Name: COLUMN base_user."F_RealName"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_RealName" IS '姓名';


--
-- Name: COLUMN base_user."F_QuickQuery"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_QuickQuery" IS '快速查询';


--
-- Name: COLUMN base_user."F_NickName"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_NickName" IS '呢称';


--
-- Name: COLUMN base_user."F_HeadIcon"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_HeadIcon" IS '头像';


--
-- Name: COLUMN base_user."F_Gender"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_Gender" IS '性别';


--
-- Name: COLUMN base_user."F_Birthday"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_Birthday" IS '生日';


--
-- Name: COLUMN base_user."F_MobilePhone"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_MobilePhone" IS '手机';


--
-- Name: COLUMN base_user."F_TelePhone"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_TelePhone" IS '电话';


--
-- Name: COLUMN base_user."F_Landline"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_Landline" IS 'F_Landline';


--
-- Name: COLUMN base_user."F_Email"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_Email" IS '邮箱';


--
-- Name: COLUMN base_user."F_Nation"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_Nation" IS '民族';


--
-- Name: COLUMN base_user."F_NativePlace"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_NativePlace" IS '籍贯';


--
-- Name: COLUMN base_user."F_EntryDate"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_EntryDate" IS '入职日期';


--
-- Name: COLUMN base_user."F_CertificatesType"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_CertificatesType" IS '证件类型';


--
-- Name: COLUMN base_user."F_CertificatesNumber"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_CertificatesNumber" IS '证件号码';


--
-- Name: COLUMN base_user."F_Education"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_Education" IS '文化程度';


--
-- Name: COLUMN base_user."F_UrgentContacts"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_UrgentContacts" IS 'F_UrgentContacts';


--
-- Name: COLUMN base_user."F_UrgentTelePhone"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_UrgentTelePhone" IS '紧急电话';


--
-- Name: COLUMN base_user."F_PostalAddress"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_PostalAddress" IS '通讯地址';


--
-- Name: COLUMN base_user."F_Signature"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_Signature" IS '自我介绍';


--
-- Name: COLUMN base_user."F_Password"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_Password" IS '密码';


--
-- Name: COLUMN base_user."F_Secretkey"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_Secretkey" IS '秘钥';


--
-- Name: COLUMN base_user."F_FirstLogTime"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_FirstLogTime" IS '首次登录时间';


--
-- Name: COLUMN base_user."F_FirstLogIP"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_FirstLogIP" IS '首次登录IP';


--
-- Name: COLUMN base_user."F_PrevLogTime"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_PrevLogTime" IS '前次登录时间';


--
-- Name: COLUMN base_user."F_PrevLogIP"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_PrevLogIP" IS '前次登录IP';


--
-- Name: COLUMN base_user."F_LastLogTime"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_LastLogTime" IS '最后登录时间';


--
-- Name: COLUMN base_user."F_LastLogIP"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_LastLogIP" IS '最后登录IP';


--
-- Name: COLUMN base_user."F_LogSuccessCount"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_LogSuccessCount" IS '登录成功次数';


--
-- Name: COLUMN base_user."F_LogErrorCount"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_LogErrorCount" IS '登录错误次数';


--
-- Name: COLUMN base_user."F_ChangePasswordDate"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_ChangePasswordDate" IS '最后修改密码时间';


--
-- Name: COLUMN base_user."F_Language"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_Language" IS '系统语言';


--
-- Name: COLUMN base_user."F_Theme"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_Theme" IS '系统样式';


--
-- Name: COLUMN base_user."F_CommonMenu"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_CommonMenu" IS '常用菜单';


--
-- Name: COLUMN base_user."F_IsAdministrator"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_IsAdministrator" IS '是否管理员';


--
-- Name: COLUMN base_user."F_PropertyJson"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_PropertyJson" IS '扩展属性';


--
-- Name: COLUMN base_user."F_Description"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_Description" IS '描述';


--
-- Name: COLUMN base_user."F_SortCode"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_SortCode" IS '排序';


--
-- Name: COLUMN base_user."F_EnabledMark"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_EnabledMark" IS '有效标志';


--
-- Name: COLUMN base_user."F_CreatorTime"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_CreatorTime" IS '创建时间';


--
-- Name: COLUMN base_user."F_CreatorUserId"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_CreatorUserId" IS '创建用户';


--
-- Name: COLUMN base_user."F_LastModifyTime"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_LastModifyTime" IS '修改时间';


--
-- Name: COLUMN base_user."F_LastModifyUserId"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_LastModifyUserId" IS '修改用户';


--
-- Name: COLUMN base_user."F_DeleteTime"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_DeleteTime" IS '删除时间';


--
-- Name: COLUMN base_user."F_DeleteUserId"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_DeleteUserId" IS '删除用户';


--
-- Name: COLUMN base_user."F_DeleteMark"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_DeleteMark" IS '删除标志';


--
-- Name: COLUMN base_user."F_ManagerId"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_ManagerId" IS '主管主键';


--
-- Name: COLUMN base_user."F_OrganizeId"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_OrganizeId" IS '组织主键';


--
-- Name: COLUMN base_user."F_PositionId"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_PositionId" IS '岗位主键';


--
-- Name: COLUMN base_user."F_RoleId"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_RoleId" IS '角色主键';


--
-- Name: COLUMN base_user."F_LockMark"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_LockMark" IS '是否锁定';


--
-- Name: COLUMN base_user."F_UnLockTime"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.base_user."F_UnLockTime" IS '解锁时间';


--
-- Name: base_userrelation; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.base_userrelation (
    "F_Id" character varying(50) NOT NULL,
    "F_UserId" character varying(50),
    "F_ObjectType" character varying(50),
    "F_ObjectId" character varying(50),
    "F_SortCode" bigint,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50)
);


ALTER TABLE test.base_userrelation OWNER TO postgres;

--
-- Name: base_visualdev; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.base_visualdev (
    "F_Id" character varying(50) NOT NULL,
    "F_Description" text,
    "F_SortCode" bigint,
    "F_EnabledMark" integer,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteMark" integer,
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50),
    "F_FullName" character varying(100),
    "F_EnCode" character varying(50),
    "F_State" integer,
    "F_Type" integer,
    "F_Table" text,
    "F_Category" character varying(50),
    "F_FormData" text,
    "F_ColumnData" text,
    "F_Fields" text,
    "F_TemplateData" text,
    "F_DbLinkId" character varying(50),
    "F_FlowTemplateJson" text,
    "F_WebType" integer,
    "F_FLowId" character varying(50)
);


ALTER TABLE test.base_visualdev OWNER TO postgres;

--
-- Name: base_visualdev_modeldata; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.base_visualdev_modeldata (
    "F_Id" character varying(50) NOT NULL,
    "F_VisualDevId" character varying(50),
    "F_SortCode" bigint,
    "F_EnabledMark" integer,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteMark" integer,
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50),
    "F_ParentId" character varying(50),
    "F_Data" text
);


ALTER TABLE test.base_visualdev_modeldata OWNER TO postgres;

--
-- Name: blade_visual; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.blade_visual (
    id character varying(64) NOT NULL,
    title character varying(255),
    background_url text,
    category integer,
    password character varying(255),
    create_user character varying(64),
    create_dept character varying(64),
    create_time timestamp without time zone,
    update_user character varying(64),
    update_time timestamp without time zone,
    status integer NOT NULL,
    is_deleted integer NOT NULL
);


ALTER TABLE test.blade_visual OWNER TO postgres;

--
-- Name: blade_visual_category; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.blade_visual_category (
    id character varying(64) NOT NULL,
    category_key character varying(12),
    category_value character varying(64),
    is_deleted integer NOT NULL
);


ALTER TABLE test.blade_visual_category OWNER TO postgres;

--
-- Name: blade_visual_config; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.blade_visual_config (
    id character varying(64) NOT NULL,
    visual_id character varying(64),
    detail text,
    component text
);


ALTER TABLE test.blade_visual_config OWNER TO postgres;

--
-- Name: blade_visual_db; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.blade_visual_db (
    id character varying(64) NOT NULL,
    name character varying(100),
    driver_class character varying(100),
    url character varying(500),
    username character varying(50),
    password character varying(50),
    remark character varying(255),
    create_user character varying(64),
    create_dept character varying(64),
    create_time timestamp without time zone,
    update_user character varying(64),
    update_time timestamp without time zone,
    status integer,
    is_deleted integer
);


ALTER TABLE test.blade_visual_db OWNER TO postgres;

--
-- Name: blade_visual_map; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.blade_visual_map (
    id character varying(64) NOT NULL,
    name character varying(255),
    data text
);


ALTER TABLE test.blade_visual_map OWNER TO postgres;

--
-- Name: data_report; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.data_report (
    "F_Id" character varying(50) NOT NULL,
    "F_CategoryId" character varying(50),
    "F_FullName" character varying(50),
    "F_Content" text,
    "F_EnCode" character varying(50),
    "F_SortCode" character varying(50),
    "F_EnabledMark" integer,
    "F_Description" character varying(500),
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteMark" integer,
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50)
);


ALTER TABLE test.data_report OWNER TO postgres;

--
-- Name: ext_bigdata; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.ext_bigdata (
    "F_Id" character varying(50) NOT NULL,
    "F_EnCode" character varying(50),
    "F_FullName" character varying(50),
    "F_Description" text,
    "F_CreatorTime" timestamp without time zone
);


ALTER TABLE test.ext_bigdata OWNER TO postgres;

--
-- Name: ext_document; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.ext_document (
    "F_Id" character varying(50) NOT NULL,
    "F_ParentId" character varying(50),
    "F_Type" integer,
    "F_FullName" character varying(200),
    "F_FilePath" text,
    "F_FileSize" character varying(50),
    "F_FileExtension" character varying(50),
    "F_ReadcCount" integer,
    "F_IsShare" integer,
    "F_ShareTime" timestamp without time zone,
    "F_Description" text,
    "F_SortCode" bigint,
    "F_EnabledMark" integer,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteMark" integer,
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50)
);


ALTER TABLE test.ext_document OWNER TO postgres;

--
-- Name: ext_documentshare; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.ext_documentshare (
    "F_Id" character varying(50) NOT NULL,
    "F_DocumentId" character varying(50),
    "F_ShareUserId" character varying(50),
    "F_ShareTime" timestamp without time zone
);


ALTER TABLE test.ext_documentshare OWNER TO postgres;

--
-- Name: ext_emailconfig; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.ext_emailconfig (
    "F_Id" character varying(50) NOT NULL,
    "F_POP3Host" character varying(50),
    "F_POP3Port" integer,
    "F_SMTPHost" character varying(50),
    "F_SMTPPort" integer,
    "F_Account" character varying(50),
    "F_Password" character varying(50),
    "F_Ssl" integer,
    "F_SenderName" character varying(50),
    "F_FolderJson" text,
    "F_Description" text,
    "F_SortCode" bigint,
    "F_EnabledMark" integer,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50)
);


ALTER TABLE test.ext_emailconfig OWNER TO postgres;

--
-- Name: ext_emailreceive; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.ext_emailreceive (
    "F_Id" character varying(50) NOT NULL,
    "F_Type" integer,
    "F_MAccount" character varying(50),
    "F_MID" character varying(200),
    "F_Sender" character varying(50),
    "F_SenderName" character varying(50),
    "F_Subject" character varying(200),
    "F_BodyText" text,
    "F_Attachment" text,
    "F_Read" integer,
    "F_Date" timestamp without time zone,
    "F_Starred" integer,
    "F_Description" text,
    "F_SortCode" bigint,
    "F_EnabledMark" integer,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteMark" integer,
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50)
);


ALTER TABLE test.ext_emailreceive OWNER TO postgres;

--
-- Name: ext_emailsend; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.ext_emailsend (
    "F_Id" character varying(50) NOT NULL,
    "F_Type" integer,
    "F_Sender" text,
    "F_To" text,
    "F_CC" text,
    "F_BCC" text,
    "F_Colour" character varying(50),
    "F_Subject" character varying(200),
    "F_BodyText" text,
    "F_Attachment" text,
    "F_State" integer,
    "F_Description" text,
    "F_SortCode" bigint,
    "F_EnabledMark" integer,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteMark" integer,
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50)
);


ALTER TABLE test.ext_emailsend OWNER TO postgres;

--
-- Name: ext_employee; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.ext_employee (
    "F_Id" character varying(50) NOT NULL,
    "F_EnCode" character varying(50),
    "F_FullName" character varying(50),
    "F_Gender" character varying(50),
    "F_DepartmentName" character varying(50),
    "F_PositionName" character varying(50),
    "F_WorkingNature" character varying(50),
    "F_IDNumber" character varying(50),
    "F_Telephone" character varying(50),
    "F_AttendWorkTime" timestamp without time zone,
    "F_Birthday" timestamp without time zone,
    "F_Education" character varying(50),
    "F_Major" character varying(50),
    "F_GraduationAcademy" character varying(50),
    "F_GraduationTime" timestamp without time zone,
    "F_Description" text,
    "F_SortCode" bigint,
    "F_EnabledMark" integer,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteMark" integer,
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50)
);


ALTER TABLE test.ext_employee OWNER TO postgres;

--
-- Name: ext_order; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.ext_order (
    "F_Id" character varying(50) NOT NULL,
    "F_CustomerId" character varying(50),
    "F_CustomerName" character varying(50),
    "F_SalesmanId" character varying(50),
    "F_SalesmanName" character varying(50),
    "F_OrderDate" timestamp without time zone,
    "F_OrderCode" character varying(50),
    "F_TransportMode" character varying(50),
    "F_DeliveryDate" timestamp without time zone,
    "F_DeliveryAddress" text,
    "F_PaymentMode" character varying(50),
    "F_ReceivableMoney" numeric(18,2),
    "F_EarnestRate" numeric(18,2),
    "F_PrepayEarnest" numeric(18,2),
    "F_CurrentState" integer,
    "F_FileJson" text,
    "F_Description" text,
    "F_SortCode" bigint,
    "F_EnabledMark" integer,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteMark" integer,
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50)
);


ALTER TABLE test.ext_order OWNER TO postgres;

--
-- Name: ext_orderentry; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.ext_orderentry (
    "F_Id" character varying(50) NOT NULL,
    "F_OrderId" character varying(50),
    "F_GoodsId" character varying(50),
    "F_GoodsCode" character varying(50),
    "F_GoodsName" character varying(50),
    "F_Specifications" character varying(50),
    "F_Unit" character varying(50),
    "F_Qty" numeric(18,2),
    "F_Price" numeric(18,2),
    "F_Amount" numeric(18,2),
    "F_Discount" numeric(18,2),
    "F_Cess" numeric(18,2),
    "F_ActualPrice" numeric(18,2),
    "F_ActualAmount" numeric(18,2),
    "F_Description" text,
    "F_SortCode" bigint
);


ALTER TABLE test.ext_orderentry OWNER TO postgres;

--
-- Name: ext_orderreceivable; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.ext_orderreceivable (
    "F_Id" character varying(50) NOT NULL,
    "F_OrderId" character varying(50),
    "F_Abstract" text,
    "F_ReceivableDate" timestamp without time zone,
    "F_ReceivableRate" numeric(18,2),
    "F_ReceivableMoney" numeric(18,2),
    "F_ReceivableMode" character varying(50),
    "F_ReceivableState" integer,
    "F_Description" text,
    "F_SortCode" bigint
);


ALTER TABLE test.ext_orderreceivable OWNER TO postgres;

--
-- Name: ext_projectgantt; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.ext_projectgantt (
    "F_Id" character varying(50) NOT NULL,
    "F_ParentId" character varying(50),
    "F_ProjectId" character varying(50),
    "F_Type" integer,
    "F_EnCode" character varying(50),
    "F_FullName" character varying(50),
    "F_TimeLimit" numeric(18,0),
    "F_Sign" character varying(50),
    "F_SignColor" character varying(50),
    "F_StartTime" timestamp without time zone,
    "F_EndTime" timestamp without time zone,
    "F_Schedule" integer,
    "F_ManagerIds" text,
    "F_Description" text,
    "F_SortCode" bigint,
    "F_EnabledMark" integer,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteMark" integer,
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50),
    "F_State" integer
);


ALTER TABLE test.ext_projectgantt OWNER TO postgres;

--
-- Name: ext_schedule; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.ext_schedule (
    "F_Id" character varying(50) NOT NULL,
    "F_Title" character varying(50),
    "F_Content" text,
    "F_Colour" character varying(50),
    "F_ColourCss" character varying(50),
    "F_StartTime" timestamp without time zone,
    "F_EndTime" timestamp without time zone,
    "F_AppAlert" integer,
    "F_Early" integer,
    "F_MailAlert" integer,
    "F_WeChatAlert" integer,
    "F_MobileAlert" integer,
    "F_SystemAlert" integer,
    "F_Description" text,
    "F_SortCode" bigint,
    "F_EnabledMark" integer,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteMark" integer,
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50)
);


ALTER TABLE test.ext_schedule OWNER TO postgres;

--
-- Name: ext_tableexample; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.ext_tableexample (
    "F_Id" character varying(50) NOT NULL,
    "F_InteractionDate" timestamp without time zone,
    "F_ProjectCode" character varying(50),
    "F_ProjectName" character varying(50),
    "F_Principal" character varying(50),
    "F_JackStands" character varying(50),
    "F_ProjectType" character varying(50),
    "F_ProjectPhase" character varying(200),
    "F_CustomerName" character varying(50),
    "F_CostAmount" numeric(18,2),
    "F_TunesAmount" numeric(18,2),
    "F_ProjectedIncome" numeric(18,2),
    "F_Registrant" character varying(50),
    "F_RegisterDate" timestamp without time zone,
    "F_Description" text,
    "F_Sign" text,
    "F_PostilJson" text,
    "F_PostilCount" integer,
    "F_EnabledMark" integer,
    "F_SortCode" bigint,
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50)
);


ALTER TABLE test.ext_tableexample OWNER TO postgres;

--
-- Name: ext_worklog; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.ext_worklog (
    "F_Id" character varying(50) NOT NULL,
    "F_Title" character varying(50),
    "F_TodayContent" text,
    "F_TomorrowContent" text,
    "F_Question" text,
    "F_ToUserId" text,
    "F_Description" text,
    "F_SortCode" bigint,
    "F_EnabledMark" integer,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteMark" integer,
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50)
);


ALTER TABLE test.ext_worklog OWNER TO postgres;

--
-- Name: ext_worklogshare; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.ext_worklogshare (
    "F_Id" character varying(50) NOT NULL,
    "F_WorkLogId" character varying(50),
    "F_ShareUserId" character varying(50),
    "F_ShareTime" timestamp without time zone
);


ALTER TABLE test.ext_worklogshare OWNER TO postgres;

--
-- Name: flow_candidates; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.flow_candidates (
    "F_Id" character varying(50) NOT NULL,
    "F_TaskNodeId" character varying(50),
    "F_HandleId" character varying(50),
    "F_Account" character varying(50),
    "F_Candidates" text,
    "F_TaskId" character varying(50),
    "F_TaskOperatorId" character varying(50)
);


ALTER TABLE test.flow_candidates OWNER TO postgres;

--
-- Name: flow_comment; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.flow_comment (
    "F_Id" character varying(50) NOT NULL,
    "F_TaskId" character varying(50),
    "F_Text" text,
    "F_Image" text,
    "F_File" text,
    "F_EnabledMark" integer,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteMark" integer,
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50)
);


ALTER TABLE test.flow_comment OWNER TO postgres;

--
-- Name: flow_delegate; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.flow_delegate (
    "F_Id" character varying(50) NOT NULL,
    "F_ToUserId" character varying(50),
    "F_ToUserName" character varying(50),
    "F_FlowId" character varying(50),
    "F_FlowName" character varying(50),
    "F_FlowCategory" character varying(50),
    "F_StartTime" timestamp without time zone,
    "F_EndTime" timestamp without time zone,
    "F_Description" text,
    "F_SortCode" bigint,
    "F_EnabledMark" integer,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteMark" integer,
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50)
);


ALTER TABLE test.flow_delegate OWNER TO postgres;

--
-- Name: flow_engine; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.flow_engine (
    "F_Id" character varying(50) NOT NULL,
    "F_EnCode" character varying(50),
    "F_FullName" character varying(50),
    "F_Type" integer,
    "F_Category" character varying(50),
    "F_Form" character varying(50),
    "F_VisibleType" integer,
    "F_Icon" character varying(50),
    "F_IconBackground" character varying(50),
    "F_Version" character varying(50),
    "F_FlowTemplateJson" text,
    "F_Description" text,
    "F_SortCode" bigint,
    "F_EnabledMark" integer,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteMark" integer,
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50),
    "F_FormTemplateJson" text,
    "F_FormType" integer,
    "F_Tables" text,
    "F_AppFormUrl" character varying(200),
    "F_FormUrl" character varying(200),
    "F_DbLinkId" character varying(50)
);


ALTER TABLE test.flow_engine OWNER TO postgres;

--
-- Name: flow_engineform; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.flow_engineform (
    "F_Id" character varying(50) NOT NULL,
    "F_EnCode" character varying(50),
    "F_FullName" character varying(50),
    "F_Type" integer,
    "F_Category" character varying(50),
    "F_UrlAddress" text,
    "F_AppUrlAddress" text,
    "F_PropertyJson" text,
    "F_Description" text,
    "F_SortCode" bigint,
    "F_EnabledMark" integer,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteMark" integer,
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50)
);


ALTER TABLE test.flow_engineform OWNER TO postgres;

--
-- Name: flow_enginevisible; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.flow_enginevisible (
    "F_Id" character varying(50) NOT NULL,
    "F_FlowId" character varying(50),
    "F_OperatorType" character varying(50),
    "F_OperatorId" character varying(50),
    "F_SortCode" bigint,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50)
);


ALTER TABLE test.flow_enginevisible OWNER TO postgres;

--
-- Name: flow_task; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.flow_task (
    "F_Id" character varying(50) NOT NULL,
    "F_ProcessId" character varying(50),
    "F_EnCode" character varying(50),
    "F_FullName" character varying(200),
    "F_FlowUrgent" integer,
    "F_FlowId" character varying(50),
    "F_FlowCode" character varying(50),
    "F_FlowName" character varying(50),
    "F_FlowType" integer,
    "F_FlowCategory" character varying(50),
    "F_FlowForm" text,
    "F_FlowFormContentJson" text,
    "F_FlowTemplateJson" text,
    "F_FlowVersion" character varying(50),
    "F_StartTime" timestamp without time zone,
    "F_EndTime" timestamp without time zone,
    "F_ThisStep" character varying(50),
    "F_ThisStepId" character varying(50),
    "F_Grade" character varying(50),
    "F_Status" integer,
    "F_Completion" integer,
    "F_Description" text,
    "F_SortCode" bigint,
    "F_EnabledMark" integer,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteMark" integer,
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50),
    "F_ParentId" character varying(50),
    "F_IsAsync" integer
);


ALTER TABLE test.flow_task OWNER TO postgres;

--
-- Name: flow_taskcirculate; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.flow_taskcirculate (
    "F_Id" character varying(50) NOT NULL,
    "F_ObjectType" character varying(50),
    "F_ObjectId" character varying(50),
    "F_NodeCode" character varying(50),
    "F_NodeName" character varying(50),
    "F_TaskNodeId" character varying(50),
    "F_TaskId" character varying(50),
    "F_CreatorTime" timestamp without time zone
);


ALTER TABLE test.flow_taskcirculate OWNER TO postgres;

--
-- Name: flow_tasknode; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.flow_tasknode (
    "F_Id" character varying(50) NOT NULL,
    "F_NodeCode" character varying(50),
    "F_NodeName" character varying(50),
    "F_NodeType" character varying(50),
    "F_NodePropertyJson" text,
    "F_NodeUp" character varying(50),
    "F_NodeNext" character varying(50),
    "F_Completion" integer,
    "F_Description" text,
    "F_SortCode" bigint,
    "F_CreatorTime" timestamp without time zone,
    "F_TaskId" character varying(50),
    "F_State" character varying(50),
    "F_Candidates" text
);


ALTER TABLE test.flow_tasknode OWNER TO postgres;

--
-- Name: flow_taskoperator; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.flow_taskoperator (
    "F_Id" character varying(50) NOT NULL,
    "F_HandleType" character varying(50),
    "F_HandleId" character varying(50),
    "F_HandleStatus" integer,
    "F_HandleTime" timestamp without time zone,
    "F_NodeCode" character varying(50),
    "F_NodeName" character varying(50),
    "F_Completion" integer,
    "F_Description" text,
    "F_CreatorTime" timestamp without time zone,
    "F_TaskNodeId" character varying(50),
    "F_TaskId" character varying(50),
    "F_Type" character varying(50),
    "F_State" character varying(50),
    "F_ParentId" character varying(50),
    "F_DraftData" text
);


ALTER TABLE test.flow_taskoperator OWNER TO postgres;

--
-- Name: flow_taskoperatorrecord; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.flow_taskoperatorrecord (
    "F_Id" character varying(50) NOT NULL,
    "F_NodeCode" character varying(50),
    "F_NodeName" character varying(50),
    "F_HandleStatus" integer,
    "F_HandleId" character varying(50),
    "F_HandleTime" timestamp without time zone,
    "F_HandleOpinion" text,
    "F_TaskOperatorId" character varying(50),
    "F_TaskNodeId" character varying(50),
    "F_TaskId" character varying(50),
    "F_SignImg" text,
    "F_Status" integer,
    "F_OperatorId" character varying(50)
);


ALTER TABLE test.flow_taskoperatorrecord OWNER TO postgres;

--
-- Name: jck_qyk_qyjcxx; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.jck_qyk_qyjcxx (
    qywybs character varying(32) NOT NULL,
    qybm character varying(50) NOT NULL,
    qymc character varying(50) NOT NULL,
    qyshtyxydm character varying(50) NOT NULL,
    zzjgdmzh character varying(50) NOT NULL,
    yyzzh character varying(100),
    clsj timestamp without time zone,
    cz character varying(50),
    dzyx character varying(100),
    jjlx character varying(50),
    lxdh2 character varying(100),
    lxrdh character varying(100),
    lxrsjhm character varying(100),
    lxrxm character varying(50),
    qybgdz character varying(200),
    qybgdzyzbm character varying(50),
    qyfl character varying(50),
    fddbrsfzjhm character varying(50),
    qyfrxm character varying(50),
    fddbrzc character varying(50),
    fddbrzw character varying(50),
    qygs character varying(100),
    qylb character varying(100),
    qywz character varying(200),
    qyxz character varying(100),
    qyzcdz character varying(200),
    qyzcdzyzbm character varying(50),
    zcszd character varying(50),
    zcszs character varying(50),
    zcszx character varying(50),
    xxdz character varying(300),
    zcbz character varying(50),
    zczj character varying(50),
    qyjyfw character varying(300),
    cjr_id character varying(255),
    cj_sj character varying(255),
    xgr_id character varying(255),
    xg_sj character varying(255),
    sjly character varying(255),
    lywybs character varying(255),
    qydl character varying(255),
    qyel character varying(255),
    xzqh character varying(255),
    qyjydz character varying(255),
    qyyydzyzbm character varying(255),
    frdbsfzjlx character varying(255),
    frdnsfzjhm character varying(255),
    qydjzclx character varying(255),
    zczb character varying(255),
    sszb character varying(255),
    zzzbhb character varying(255),
    clrq timestamp without time zone,
    bgdh character varying(255),
    lxrbgsdh character varying(255),
    lxrsjh character varying(255),
    lxyx character varying(255),
    yyqxq timestamp without time zone,
    yyqxz timestamp without time zone,
    jyfw character varying(1000),
    jjyfw character varying(300),
    djjg character varying(100),
    yyzzzt character varying(255),
    zywyglrq timestamp without time zone,
    sfzbs integer,
    zbmc character varying(255),
    zbdz character varying(255),
    zbclrq timestamp without time zone,
    zbyb character varying(255),
    zbcz character varying(255),
    zblxr character varying(255),
    zblxdh character varying(255),
    zbyx character varying(255),
    fzjgtyyzch character varying(255),
    znyyzzh character varying(255),
    qyfwlx character varying(255),
    qyqy character varying(10),
    qycshy character varying(10),
    qycshymc character varying(10)
);


ALTER TABLE test.jck_qyk_qyjcxx OWNER TO postgres;

--
-- Name: TABLE jck_qyk_qyjcxx; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON TABLE test.jck_qyk_qyjcxx IS '数字住建一体化单位信息表';


--
-- Name: COLUMN jck_qyk_qyjcxx.qywybs; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.qywybs IS '企业唯一标识';


--
-- Name: COLUMN jck_qyk_qyjcxx.qybm; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.qybm IS '企业编码';


--
-- Name: COLUMN jck_qyk_qyjcxx.qymc; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.qymc IS '企业名称';


--
-- Name: COLUMN jck_qyk_qyjcxx.qyshtyxydm; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.qyshtyxydm IS '企业社会统一信用代码';


--
-- Name: COLUMN jck_qyk_qyjcxx.zzjgdmzh; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.zzjgdmzh IS '组织机构代码证号';


--
-- Name: COLUMN jck_qyk_qyjcxx.yyzzh; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.yyzzh IS '营业执照号';


--
-- Name: COLUMN jck_qyk_qyjcxx.clsj; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.clsj IS '成立时间';


--
-- Name: COLUMN jck_qyk_qyjcxx.cz; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.cz IS '传真';


--
-- Name: COLUMN jck_qyk_qyjcxx.dzyx; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.dzyx IS '电子邮箱';


--
-- Name: COLUMN jck_qyk_qyjcxx.jjlx; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.jjlx IS '经济类型';


--
-- Name: COLUMN jck_qyk_qyjcxx.lxdh2; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.lxdh2 IS '联系电话2';


--
-- Name: COLUMN jck_qyk_qyjcxx.lxrdh; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.lxrdh IS '联系人电话';


--
-- Name: COLUMN jck_qyk_qyjcxx.lxrsjhm; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.lxrsjhm IS '联系人手机号码';


--
-- Name: COLUMN jck_qyk_qyjcxx.lxrxm; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.lxrxm IS '联系人姓名';


--
-- Name: COLUMN jck_qyk_qyjcxx.qybgdz; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.qybgdz IS '企业办公地址';


--
-- Name: COLUMN jck_qyk_qyjcxx.qybgdzyzbm; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.qybgdzyzbm IS '企业办公地址邮政编码';


--
-- Name: COLUMN jck_qyk_qyjcxx.qyfl; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.qyfl IS '企业分类';


--
-- Name: COLUMN jck_qyk_qyjcxx.fddbrsfzjhm; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.fddbrsfzjhm IS '法定代表人身份证件号码';


--
-- Name: COLUMN jck_qyk_qyjcxx.qyfrxm; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.qyfrxm IS '企业法人姓名';


--
-- Name: COLUMN jck_qyk_qyjcxx.fddbrzc; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.fddbrzc IS '法定代表人职称';


--
-- Name: COLUMN jck_qyk_qyjcxx.fddbrzw; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.fddbrzw IS '法定代表人职务';


--
-- Name: COLUMN jck_qyk_qyjcxx.qygs; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.qygs IS '企业归属';


--
-- Name: COLUMN jck_qyk_qyjcxx.qylb; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.qylb IS '企业类别';


--
-- Name: COLUMN jck_qyk_qyjcxx.qywz; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.qywz IS '企业网址';


--
-- Name: COLUMN jck_qyk_qyjcxx.qyxz; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.qyxz IS '企业性质';


--
-- Name: COLUMN jck_qyk_qyjcxx.qyzcdz; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.qyzcdz IS '企业注册地址';


--
-- Name: COLUMN jck_qyk_qyjcxx.qyzcdzyzbm; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.qyzcdzyzbm IS '企业注册地址邮政编码';


--
-- Name: COLUMN jck_qyk_qyjcxx.zcszd; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.zcszd IS '工商注册所在地';


--
-- Name: COLUMN jck_qyk_qyjcxx.zcszs; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.zcszs IS '工商注册所在省';


--
-- Name: COLUMN jck_qyk_qyjcxx.zcszx; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.zcszx IS '工商注册所在区县';


--
-- Name: COLUMN jck_qyk_qyjcxx.xxdz; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.xxdz IS '详细地址';


--
-- Name: COLUMN jck_qyk_qyjcxx.zcbz; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.zcbz IS '注册币种';


--
-- Name: COLUMN jck_qyk_qyjcxx.zczj; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.zczj IS '注册资金（万元）';


--
-- Name: COLUMN jck_qyk_qyjcxx.qyjyfw; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.qyjyfw IS '企业经营范围';


--
-- Name: COLUMN jck_qyk_qyjcxx.cjr_id; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.cjr_id IS '创建人';


--
-- Name: COLUMN jck_qyk_qyjcxx.cj_sj; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.cj_sj IS '创建时间';


--
-- Name: COLUMN jck_qyk_qyjcxx.xgr_id; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.xgr_id IS '修改人';


--
-- Name: COLUMN jck_qyk_qyjcxx.xg_sj; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.xg_sj IS '修改时间';


--
-- Name: COLUMN jck_qyk_qyjcxx.sjly; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.sjly IS '数据来源';


--
-- Name: COLUMN jck_qyk_qyjcxx.lywybs; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.lywybs IS '来源唯一标识ID';


--
-- Name: COLUMN jck_qyk_qyjcxx.qydl; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.qydl IS '企业大类';


--
-- Name: COLUMN jck_qyk_qyjcxx.qyel; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.qyel IS '企业二类';


--
-- Name: COLUMN jck_qyk_qyjcxx.xzqh; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.xzqh IS '行政区划';


--
-- Name: COLUMN jck_qyk_qyjcxx.qyjydz; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.qyjydz IS '企业营业地址';


--
-- Name: COLUMN jck_qyk_qyjcxx.qyyydzyzbm; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.qyyydzyzbm IS '企业营业地址邮政编码';


--
-- Name: COLUMN jck_qyk_qyjcxx.frdbsfzjlx; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.frdbsfzjlx IS '法定代表人身份证件类型';


--
-- Name: COLUMN jck_qyk_qyjcxx.frdnsfzjhm; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.frdnsfzjhm IS '法定代表人身份证件号码';


--
-- Name: COLUMN jck_qyk_qyjcxx.qydjzclx; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.qydjzclx IS '企业登记注册类型';


--
-- Name: COLUMN jck_qyk_qyjcxx.zczb; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.zczb IS '注册资本（万元）';


--
-- Name: COLUMN jck_qyk_qyjcxx.sszb; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.sszb IS '实收资本（万元）';


--
-- Name: COLUMN jck_qyk_qyjcxx.zzzbhb; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.zzzbhb IS '注册资本币种';


--
-- Name: COLUMN jck_qyk_qyjcxx.clrq; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.clrq IS '成立日期';


--
-- Name: COLUMN jck_qyk_qyjcxx.bgdh; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.bgdh IS '办公电话';


--
-- Name: COLUMN jck_qyk_qyjcxx.lxrbgsdh; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.lxrbgsdh IS '联系人办公电话';


--
-- Name: COLUMN jck_qyk_qyjcxx.lxrsjh; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.lxrsjh IS '联系人手机号码';


--
-- Name: COLUMN jck_qyk_qyjcxx.lxyx; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.lxyx IS '联系邮箱';


--
-- Name: COLUMN jck_qyk_qyjcxx.yyqxq; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.yyqxq IS '营业期限起';


--
-- Name: COLUMN jck_qyk_qyjcxx.yyqxz; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.yyqxz IS '营业期限止';


--
-- Name: COLUMN jck_qyk_qyjcxx.jyfw; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.jyfw IS '经营范围';


--
-- Name: COLUMN jck_qyk_qyjcxx.jjyfw; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.jjyfw IS '兼营范围';


--
-- Name: COLUMN jck_qyk_qyjcxx.djjg; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.djjg IS '登记机关';


--
-- Name: COLUMN jck_qyk_qyjcxx.yyzzzt; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.yyzzzt IS '营业执照状态';


--
-- Name: COLUMN jck_qyk_qyjcxx.zywyglrq; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.zywyglrq IS '准予物业管理日期';


--
-- Name: COLUMN jck_qyk_qyjcxx.sfzbs; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.sfzbs IS '是否驻本市';


--
-- Name: COLUMN jck_qyk_qyjcxx.zbmc; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.zbmc IS '总部名称';


--
-- Name: COLUMN jck_qyk_qyjcxx.zbdz; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.zbdz IS '总部地址';


--
-- Name: COLUMN jck_qyk_qyjcxx.zbclrq; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.zbclrq IS '总部成立日期';


--
-- Name: COLUMN jck_qyk_qyjcxx.zbyb; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.zbyb IS '总部邮编';


--
-- Name: COLUMN jck_qyk_qyjcxx.zbcz; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.zbcz IS '总部传真';


--
-- Name: COLUMN jck_qyk_qyjcxx.zblxr; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.zblxr IS '总部联系人';


--
-- Name: COLUMN jck_qyk_qyjcxx.zblxdh; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.zblxdh IS '总部联系电话';


--
-- Name: COLUMN jck_qyk_qyjcxx.zbyx; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.zbyx IS '总部邮箱';


--
-- Name: COLUMN jck_qyk_qyjcxx.fzjgtyyzch; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.fzjgtyyzch IS '分支机构营业注册号';


--
-- Name: COLUMN jck_qyk_qyjcxx.znyyzzh; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.znyyzzh IS '总部营业执照号';


--
-- Name: COLUMN jck_qyk_qyjcxx.qyfwlx; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.qyfwlx IS '企业单位类型';


--
-- Name: COLUMN jck_qyk_qyjcxx.qyqy; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.qyqy IS '企业区域';


--
-- Name: COLUMN jck_qyk_qyjcxx.qycshy; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.qycshy IS '企业从事行业';


--
-- Name: COLUMN jck_qyk_qyjcxx.qycshymc; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_qyk_qyjcxx.qycshymc IS '企业从事行业名称';


--
-- Name: jck_ryk_ryjcxx; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.jck_ryk_ryjcxx (
    ryjbxxwybs character varying(32) NOT NULL,
    qywybs character varying(32) NOT NULL,
    xm character varying(50) NOT NULL,
    xb character varying(10),
    zjhm character varying(50) NOT NULL,
    mz character varying(50) NOT NULL,
    jg character varying(200) NOT NULL,
    csrq timestamp without time zone,
    dzyx character varying(100),
    lxfs character varying(50),
    ryjlh character varying(100),
    rylx character varying(50),
    rybh character varying(1000),
    sbkh character varying(50),
    zjlx character varying(100),
    sdlb character varying(50),
    txdz character varying(200),
    yzbm character varying(50),
    create_user character varying(255),
    create_time timestamp without time zone,
    update_user character varying(255),
    update_time timestamp without time zone,
    sjly character varying(255),
    lywybs character varying(255)
);


ALTER TABLE test.jck_ryk_ryjcxx OWNER TO postgres;

--
-- Name: TABLE jck_ryk_ryjcxx; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON TABLE test.jck_ryk_ryjcxx IS '数字住建一体化人员信息表';


--
-- Name: COLUMN jck_ryk_ryjcxx.ryjbxxwybs; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_ryk_ryjcxx.ryjbxxwybs IS '人员基本信息唯一标识';


--
-- Name: COLUMN jck_ryk_ryjcxx.qywybs; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_ryk_ryjcxx.qywybs IS '所属企业唯一标识';


--
-- Name: COLUMN jck_ryk_ryjcxx.xm; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_ryk_ryjcxx.xm IS '姓名';


--
-- Name: COLUMN jck_ryk_ryjcxx.xb; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_ryk_ryjcxx.xb IS '性别，参照字典zd_xb';


--
-- Name: COLUMN jck_ryk_ryjcxx.zjhm; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_ryk_ryjcxx.zjhm IS '证件号码';


--
-- Name: COLUMN jck_ryk_ryjcxx.mz; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_ryk_ryjcxx.mz IS '民族';


--
-- Name: COLUMN jck_ryk_ryjcxx.jg; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_ryk_ryjcxx.jg IS '籍贯';


--
-- Name: COLUMN jck_ryk_ryjcxx.csrq; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_ryk_ryjcxx.csrq IS '出生日期';


--
-- Name: COLUMN jck_ryk_ryjcxx.dzyx; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_ryk_ryjcxx.dzyx IS '电子邮箱';


--
-- Name: COLUMN jck_ryk_ryjcxx.lxfs; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_ryk_ryjcxx.lxfs IS '联系方式';


--
-- Name: COLUMN jck_ryk_ryjcxx.ryjlh; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_ryk_ryjcxx.ryjlh IS '人员记录号';


--
-- Name: COLUMN jck_ryk_ryjcxx.rylx; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_ryk_ryjcxx.rylx IS '人员类型，参照字典zd_rylx';


--
-- Name: COLUMN jck_ryk_ryjcxx.rybh; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_ryk_ryjcxx.rybh IS '人员编号';


--
-- Name: COLUMN jck_ryk_ryjcxx.sbkh; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_ryk_ryjcxx.sbkh IS '社保卡号';


--
-- Name: COLUMN jck_ryk_ryjcxx.zjlx; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_ryk_ryjcxx.zjlx IS '证件类型，参照字典zd_zjlx';


--
-- Name: COLUMN jck_ryk_ryjcxx.sdlb; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_ryk_ryjcxx.sdlb IS '属地类别，参照字典zd_sdlb';


--
-- Name: COLUMN jck_ryk_ryjcxx.txdz; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_ryk_ryjcxx.txdz IS '通讯地址';


--
-- Name: COLUMN jck_ryk_ryjcxx.yzbm; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_ryk_ryjcxx.yzbm IS '邮政编码';


--
-- Name: COLUMN jck_ryk_ryjcxx.create_user; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_ryk_ryjcxx.create_user IS '创建人';


--
-- Name: COLUMN jck_ryk_ryjcxx.create_time; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_ryk_ryjcxx.create_time IS '创建时间';


--
-- Name: COLUMN jck_ryk_ryjcxx.update_user; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_ryk_ryjcxx.update_user IS '修改人';


--
-- Name: COLUMN jck_ryk_ryjcxx.update_time; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_ryk_ryjcxx.update_time IS '修改时间';


--
-- Name: COLUMN jck_ryk_ryjcxx.sjly; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_ryk_ryjcxx.sjly IS '数据来源';


--
-- Name: COLUMN jck_ryk_ryjcxx.lywybs; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_ryk_ryjcxx.lywybs IS '来源唯一标识id';


--
-- Name: jck_t_gc_jcqyinfo; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.jck_t_gc_jcqyinfo (
    uuid character varying(64) NOT NULL,
    sgxkz_uuid character varying(64),
    qywybs character varying(100),
    qymc character varying(500),
    qyshtyxydm character varying(255),
    qydjzclx character varying(255),
    qyfl character varying(255),
    qyfwlx character varying(255),
    qyzcdz character varying(255),
    qyzx character varying(255),
    qybgdz character varying(255),
    lxrdh character varying(255),
    lxrxm character varying(255),
    qylx character varying(255),
    gc_code character varying(255),
    gc_dm character varying(255)
);


ALTER TABLE test.jck_t_gc_jcqyinfo OWNER TO postgres;

--
-- Name: TABLE jck_t_gc_jcqyinfo; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON TABLE test.jck_t_gc_jcqyinfo IS '数字住建一体化参建单位信息表';


--
-- Name: COLUMN jck_t_gc_jcqyinfo.uuid; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_jcqyinfo.uuid IS '唯一标识';


--
-- Name: COLUMN jck_t_gc_jcqyinfo.sgxkz_uuid; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_jcqyinfo.sgxkz_uuid IS '施工许可证uuid';


--
-- Name: COLUMN jck_t_gc_jcqyinfo.qywybs; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_jcqyinfo.qywybs IS '企业唯一标识';


--
-- Name: COLUMN jck_t_gc_jcqyinfo.qymc; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_jcqyinfo.qymc IS '企业名称';


--
-- Name: COLUMN jck_t_gc_jcqyinfo.qyshtyxydm; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_jcqyinfo.qyshtyxydm IS '企业社会统一信用代码';


--
-- Name: COLUMN jck_t_gc_jcqyinfo.qydjzclx; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_jcqyinfo.qydjzclx IS '企业登记注册类型';


--
-- Name: COLUMN jck_t_gc_jcqyinfo.qyfl; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_jcqyinfo.qyfl IS '企业分类';


--
-- Name: COLUMN jck_t_gc_jcqyinfo.qyfwlx; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_jcqyinfo.qyfwlx IS '企业单位类型附录';


--
-- Name: COLUMN jck_t_gc_jcqyinfo.qyzcdz; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_jcqyinfo.qyzcdz IS '企业注册地址';


--
-- Name: COLUMN jck_t_gc_jcqyinfo.qyzx; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_jcqyinfo.qyzx IS '企业性质';


--
-- Name: COLUMN jck_t_gc_jcqyinfo.qybgdz; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_jcqyinfo.qybgdz IS '企业办公地址';


--
-- Name: COLUMN jck_t_gc_jcqyinfo.lxrdh; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_jcqyinfo.lxrdh IS '联系人电话';


--
-- Name: COLUMN jck_t_gc_jcqyinfo.lxrxm; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_jcqyinfo.lxrxm IS '联系人姓名';


--
-- Name: COLUMN jck_t_gc_jcqyinfo.qylx; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_jcqyinfo.qylx IS '企业类型：1:施工总包、2:劳务分包、3:专业承包';


--
-- Name: COLUMN jck_t_gc_jcqyinfo.gc_code; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_jcqyinfo.gc_code IS '工程编码';


--
-- Name: jck_t_gc_sgxkz; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.jck_t_gc_sgxkz (
    sgxkz_uuid character varying(64) NOT NULL,
    sgxkz_zh character varying(255),
    sgxkz_jsdwmc character varying(255),
    sgxkz_gcmc character varying(500),
    sgxkz_jsdz character varying(255),
    sgxkz_jsgm text,
    sgxkz_htj character varying(255),
    sgxkz_kcdw character varying(255),
    sgxkz_sjdw character varying(255),
    sgxkz_jldw character varying(255),
    sgxkz_sgdw character varying(255),
    sgxkz_kcdwfzr character varying(200),
    sgxkz_sjdwfzr character varying(200),
    sgxkz_jldwfzr character varying(200),
    sgxkz_sgdwfzr character varying(200),
    sgxkz_hggq character varying(255),
    sgxkz_bz text,
    sgxkz_stbh character varying(255),
    sgxkz_stsj character varying(255),
    sgxkz_aqdjrq timestamp without time zone,
    sgxkz_djrq timestamp without time zone,
    sgxkz_zljddjrq timestamp without time zone,
    gc_uuid character varying(255),
    create_time timestamp without time zone,
    update_time timestamp without time zone,
    create_user character varying(255),
    update_user character varying(255),
    sgxkz_kcdw_uuid character varying(255),
    sgxkz_jldw_uuid character varying(255),
    sgxkz_sjdw_uuid character varying(255),
    sgxkz_sgdw_uuid character varying(255),
    sgxkz_kcdwfzr_uuid character varying(255),
    sgxkz_sjdwfzr_uuid character varying(255),
    sgxkz_jldwfzr_uuid character varying(255),
    sgxkz_sgdwfzr_uuid character varying(64),
    sgxkz_jsdwmc_uuid character varying(64),
    isreverse integer,
    shzt character varying(255),
    zjk character varying(255),
    jdy character varying(255),
    jsdw_lxr character varying(255),
    jsdw_lxrdh character varying(255),
    sgxkz_pzrq timestamp without time zone,
    fzsj timestamp without time zone,
    jlzbtzsbhhrq character varying(255),
    rfsjdw character varying(255),
    jcjg character varying(255),
    jcjgxmfzr character varying(255),
    gtfqwy character varying(255),
    ptf character varying(255),
    ptfjnsjhjmsj character varying(255),
    qyxydmz character varying(255),
    jhkgrq timestamp without time zone,
    jhjgrq timestamp without time zone,
    ghxkzbh character varying(255),
    tdzbh character varying(5000),
    aqy character varying(255),
    sgzbtzsbh character varying(255),
    rfsjdwxmfzr character varying(255),
    xm_bm character varying(255),
    sgxkz_zydm character varying(255),
    jdy_name character varying(255),
    sjjgsj timestamp without time zone,
    xm_code character varying(255),
    xzqhdm character varying(255),
    bjdh character varying(255),
    djzzybs character varying(255),
    xm_dm character varying(255),
    xm_bh character varying(255),
    blspsl_bm character varying(255),
    jsydghxkzbh character varying(255),
    jsgcghxkzbh character varying(255),
    sgtschgsbh character varying(255),
    bcsqnr character varying(255),
    htgq character varying(255),
    hjdsjzmj character varying(255),
    hjdxjzmj character varying(255),
    hjrfmj character varying(255),
    hjjzmj character varying(255),
    jsxz character varying(255),
    fzjg character varying(255),
    fzjg_tyshxydm character varying(255),
    fzrq timestamp without time zone,
    jldjrq timestamp without time zone,
    xmfzd character varying(255),
    xmfl character varying(255),
    zdgclx character varying(255),
    bdbm character varying(255),
    sgxkzfzbm character varying(255),
    xmwzjd character varying(255),
    xmwzwd character varying(255),
    jsdw_tyshxydm character varying(255),
    jsdw_lx character varying(255),
    jsdw_xmfzr character varying(255),
    jsdw_xmfzrzjhm character varying(255),
    jsdw_xmfzrzjlx character varying(255),
    jsdw_xmfzrlxfs character varying(255),
    glsd character varying(255),
    sgxkz_kcdw_tyshxydm character varying(255),
    sgxkz_sjdw_tyshxydm character varying(255),
    sgxkz_jldw_tyshxydm character varying(255),
    sgxkz_sgdw_tyshxydm character varying(255),
    gcxm_zj_wybs character varying(255),
    gcxm_zj_name character varying(255),
    gcxm_jl_wybs character varying(255),
    gcxm_jl_name character varying(255),
    gc_xmuuid character varying(255),
    gc_code character varying(255),
    gc_dm character varying(255)
);


ALTER TABLE test.jck_t_gc_sgxkz OWNER TO postgres;

--
-- Name: TABLE jck_t_gc_sgxkz; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON TABLE test.jck_t_gc_sgxkz IS '数字住建一体化工程信息表';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgxkz_uuid; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgxkz_uuid IS '施工许可证uuid';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgxkz_zh; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgxkz_zh IS '施工许可证号';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgxkz_jsdwmc; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgxkz_jsdwmc IS '建设单位名称';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgxkz_gcmc; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgxkz_gcmc IS '工程名称';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgxkz_jsdz; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgxkz_jsdz IS '建设地址';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgxkz_jsgm; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgxkz_jsgm IS '建设规模';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgxkz_htj; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgxkz_htj IS '合同价';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgxkz_kcdw; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgxkz_kcdw IS '勘察单位';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgxkz_sjdw; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgxkz_sjdw IS '设计单位';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgxkz_jldw; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgxkz_jldw IS '监理单位';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgxkz_sgdw; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgxkz_sgdw IS '施工单位';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgxkz_kcdwfzr; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgxkz_kcdwfzr IS '勘察单位负责人';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgxkz_sjdwfzr; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgxkz_sjdwfzr IS '设计单位负责人';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgxkz_jldwfzr; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgxkz_jldwfzr IS '监理单位负责人';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgxkz_sgdwfzr; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgxkz_sgdwfzr IS '施工单位负责人';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgxkz_hggq; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgxkz_hggq IS '合同工期';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgxkz_bz; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgxkz_bz IS '备注';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgxkz_stbh; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgxkz_stbh IS '审图编号';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgxkz_stsj; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgxkz_stsj IS '审图时间';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgxkz_aqdjrq; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgxkz_aqdjrq IS '安全登记日期';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgxkz_djrq; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgxkz_djrq IS '施工许可证登记日期';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgxkz_zljddjrq; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgxkz_zljddjrq IS '质量监督登记日期';


--
-- Name: COLUMN jck_t_gc_sgxkz.gc_uuid; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.gc_uuid IS '工程uuid';


--
-- Name: COLUMN jck_t_gc_sgxkz.create_time; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.create_time IS '创建时间';


--
-- Name: COLUMN jck_t_gc_sgxkz.update_time; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.update_time IS '修改时间';


--
-- Name: COLUMN jck_t_gc_sgxkz.create_user; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.create_user IS '创建人';


--
-- Name: COLUMN jck_t_gc_sgxkz.update_user; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.update_user IS '修改人';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgxkz_kcdw_uuid; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgxkz_kcdw_uuid IS '勘察单位ID';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgxkz_jldw_uuid; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgxkz_jldw_uuid IS '监理单位ID';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgxkz_sjdw_uuid; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgxkz_sjdw_uuid IS '设计单位ID';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgxkz_sgdw_uuid; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgxkz_sgdw_uuid IS '施工单位ID';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgxkz_kcdwfzr_uuid; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgxkz_kcdwfzr_uuid IS '勘察单位负责人ID';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgxkz_sjdwfzr_uuid; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgxkz_sjdwfzr_uuid IS '设计单位负责人ID';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgxkz_jldwfzr_uuid; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgxkz_jldwfzr_uuid IS '监理单位负责人ID';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgxkz_sgdwfzr_uuid; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgxkz_sgdwfzr_uuid IS '施工单位负责人ID';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgxkz_jsdwmc_uuid; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgxkz_jsdwmc_uuid IS '建设单位uuid';


--
-- Name: COLUMN jck_t_gc_sgxkz.isreverse; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.isreverse IS '是否逆向';


--
-- Name: COLUMN jck_t_gc_sgxkz.shzt; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.shzt IS '审核状态';


--
-- Name: COLUMN jck_t_gc_sgxkz.zjk; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.zjk IS '质检科';


--
-- Name: COLUMN jck_t_gc_sgxkz.jdy; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.jdy IS '监督员';


--
-- Name: COLUMN jck_t_gc_sgxkz.jsdw_lxr; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.jsdw_lxr IS '建设单位联系人';


--
-- Name: COLUMN jck_t_gc_sgxkz.jsdw_lxrdh; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.jsdw_lxrdh IS '建设单位联系人电话';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgxkz_pzrq; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgxkz_pzrq IS '批准日期';


--
-- Name: COLUMN jck_t_gc_sgxkz.fzsj; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.fzsj IS '发证时间';


--
-- Name: COLUMN jck_t_gc_sgxkz.jlzbtzsbhhrq; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.jlzbtzsbhhrq IS '监理中标通知书编号/日期';


--
-- Name: COLUMN jck_t_gc_sgxkz.rfsjdw; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.rfsjdw IS '人防设计单位';


--
-- Name: COLUMN jck_t_gc_sgxkz.jcjg; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.jcjg IS '检测机构';


--
-- Name: COLUMN jck_t_gc_sgxkz.jcjgxmfzr; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.jcjgxmfzr IS '检测机构项目负责人';


--
-- Name: COLUMN jck_t_gc_sgxkz.gtfqwy; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.gtfqwy IS '固体废弃物费（元）';


--
-- Name: COLUMN jck_t_gc_sgxkz.ptf; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.ptf IS '配套费（元）';


--
-- Name: COLUMN jck_t_gc_sgxkz.ptfjnsjhjmsj; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.ptfjnsjhjmsj IS '配套费缴纳时间或减免时间';


--
-- Name: COLUMN jck_t_gc_sgxkz.qyxydmz; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.qyxydmz IS '企业信用代码证';


--
-- Name: COLUMN jck_t_gc_sgxkz.jhkgrq; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.jhkgrq IS '计划开工日期';


--
-- Name: COLUMN jck_t_gc_sgxkz.jhjgrq; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.jhjgrq IS '计划竣工日期';


--
-- Name: COLUMN jck_t_gc_sgxkz.ghxkzbh; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.ghxkzbh IS '规划许可证编号';


--
-- Name: COLUMN jck_t_gc_sgxkz.tdzbh; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.tdzbh IS '土地证编号（房产证编号）';


--
-- Name: COLUMN jck_t_gc_sgxkz.aqy; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.aqy IS '安全员';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgzbtzsbh; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgzbtzsbh IS '施工中标通知书编号/日期';


--
-- Name: COLUMN jck_t_gc_sgxkz.rfsjdwxmfzr; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.rfsjdwxmfzr IS '人防设计单位项目负责人';


--
-- Name: COLUMN jck_t_gc_sgxkz.xm_bm; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.xm_bm IS '项目编号';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgxkz_zydm; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgxkz_zydm IS '施工许可证证照代码';


--
-- Name: COLUMN jck_t_gc_sgxkz.jdy_name; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.jdy_name IS '监督员姓名';


--
-- Name: COLUMN jck_t_gc_sgxkz.sjjgsj; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sjjgsj IS '实际竣工时间';


--
-- Name: COLUMN jck_t_gc_sgxkz.xm_code; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.xm_code IS '系统生成的串联码命名规则为：QD00010001';


--
-- Name: COLUMN jck_t_gc_sgxkz.xzqhdm; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.xzqhdm IS '行政区划代码';


--
-- Name: COLUMN jck_t_gc_sgxkz.bjdh; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.bjdh IS '办件单号';


--
-- Name: COLUMN jck_t_gc_sgxkz.djzzybs; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.djzzybs IS '电子证照源标识';


--
-- Name: COLUMN jck_t_gc_sgxkz.xm_dm; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.xm_dm IS '项目代码';


--
-- Name: COLUMN jck_t_gc_sgxkz.xm_bh; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.xm_bh IS '项目编号';


--
-- Name: COLUMN jck_t_gc_sgxkz.blspsl_bm; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.blspsl_bm IS '并联审批实例编码';


--
-- Name: COLUMN jck_t_gc_sgxkz.jsydghxkzbh; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.jsydghxkzbh IS '建设用地规划许可证编号';


--
-- Name: COLUMN jck_t_gc_sgxkz.jsgcghxkzbh; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.jsgcghxkzbh IS '建设工程规划许可证编号';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgtschgsbh; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgtschgsbh IS '施工图审查合格书编号';


--
-- Name: COLUMN jck_t_gc_sgxkz.bcsqnr; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.bcsqnr IS '本次申请内容';


--
-- Name: COLUMN jck_t_gc_sgxkz.htgq; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.htgq IS '合同工期';


--
-- Name: COLUMN jck_t_gc_sgxkz.hjdsjzmj; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.hjdsjzmj IS '合计地上建筑面积（㎡）';


--
-- Name: COLUMN jck_t_gc_sgxkz.hjdxjzmj; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.hjdxjzmj IS '合计地下建筑面积（㎡）';


--
-- Name: COLUMN jck_t_gc_sgxkz.hjrfmj; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.hjrfmj IS '合计人防面积（㎡）';


--
-- Name: COLUMN jck_t_gc_sgxkz.hjjzmj; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.hjjzmj IS '合计建筑面积（㎡）';


--
-- Name: COLUMN jck_t_gc_sgxkz.jsxz; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.jsxz IS '建设性质A.0.2';


--
-- Name: COLUMN jck_t_gc_sgxkz.fzjg; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.fzjg IS '发证机关';


--
-- Name: COLUMN jck_t_gc_sgxkz.fzjg_tyshxydm; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.fzjg_tyshxydm IS '发证机关统一社会信用代码';


--
-- Name: COLUMN jck_t_gc_sgxkz.fzrq; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.fzrq IS '发证日期';


--
-- Name: COLUMN jck_t_gc_sgxkz.jldjrq; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.jldjrq IS '记录登记时间';


--
-- Name: COLUMN jck_t_gc_sgxkz.xmfzd; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.xmfzd IS '项目所在地';


--
-- Name: COLUMN jck_t_gc_sgxkz.xmfl; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.xmfl IS '项目分类A.0.3';


--
-- Name: COLUMN jck_t_gc_sgxkz.zdgclx; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.zdgclx IS '重点工程类型A.0.8';


--
-- Name: COLUMN jck_t_gc_sgxkz.bdbm; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.bdbm IS '标段编码';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgxkzfzbm; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgxkzfzbm IS '施工许可发证部门';


--
-- Name: COLUMN jck_t_gc_sgxkz.xmwzjd; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.xmwzjd IS '项目位置经度';


--
-- Name: COLUMN jck_t_gc_sgxkz.xmwzwd; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.xmwzwd IS '项目位置纬度';


--
-- Name: COLUMN jck_t_gc_sgxkz.jsdw_tyshxydm; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.jsdw_tyshxydm IS '建设单位统一社会信用代码';


--
-- Name: COLUMN jck_t_gc_sgxkz.jsdw_lx; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.jsdw_lx IS '建设单位类型';


--
-- Name: COLUMN jck_t_gc_sgxkz.jsdw_xmfzr; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.jsdw_xmfzr IS '建设单位项目负责人';


--
-- Name: COLUMN jck_t_gc_sgxkz.jsdw_xmfzrzjhm; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.jsdw_xmfzrzjhm IS '建设单位项目负责人证件号码';


--
-- Name: COLUMN jck_t_gc_sgxkz.jsdw_xmfzrzjlx; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.jsdw_xmfzrzjlx IS '建设单位项目负责人证件类型';


--
-- Name: COLUMN jck_t_gc_sgxkz.jsdw_xmfzrlxfs; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.jsdw_xmfzrlxfs IS '建设单位项目负责人联系电话';


--
-- Name: COLUMN jck_t_gc_sgxkz.glsd; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.glsd IS '管理属地';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgxkz_kcdw_tyshxydm; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgxkz_kcdw_tyshxydm IS '勘察单位统一社会信用代码';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgxkz_sjdw_tyshxydm; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgxkz_sjdw_tyshxydm IS '设计单位统一社会信用代码';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgxkz_jldw_tyshxydm; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgxkz_jldw_tyshxydm IS '监理单位统一社会信用代码';


--
-- Name: COLUMN jck_t_gc_sgxkz.sgxkz_sgdw_tyshxydm; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.sgxkz_sgdw_tyshxydm IS '施工单位统一社会信用代码';


--
-- Name: COLUMN jck_t_gc_sgxkz.gcxm_zj_wybs; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.gcxm_zj_wybs IS '工程项目总监唯一标识';


--
-- Name: COLUMN jck_t_gc_sgxkz.gcxm_zj_name; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.gcxm_zj_name IS '工程项目总监名称';


--
-- Name: COLUMN jck_t_gc_sgxkz.gcxm_jl_wybs; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.gcxm_jl_wybs IS '工程项目经理唯一标识';


--
-- Name: COLUMN jck_t_gc_sgxkz.gcxm_jl_name; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.gcxm_jl_name IS '工程项目经理名称';


--
-- Name: COLUMN jck_t_gc_sgxkz.gc_xmuuid; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_gc_sgxkz.gc_xmuuid IS '项目uuid';


--
-- Name: jck_t_xm_project; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.jck_t_xm_project (
    gc_xmuuid character varying(64) NOT NULL,
    gc_xmmc character varying(500),
    gc_xmyt character varying(255),
    gc_xmjsxz character varying(64),
    gc_xmtzxz character varying(64),
    gc_ztze character varying(64),
    gc_zdmj character varying(64),
    gc_jzmj character varying(64),
    gc_ssjd character varying(100),
    gc_xmdz text,
    gc_xmlxrq timestamp without time zone,
    create_time timestamp without time zone,
    update_time timestamp without time zone,
    create_user character varying(100),
    update_user character varying(100),
    jsdw_name character varying(500),
    xm_status character varying(255),
    xm_tydm character varying(255),
    xm_bm character varying(255),
    xm_gm text,
    xm_jsdw_uuid character varying(255),
    xm_xz character varying(64),
    xm_dkbh character varying(255),
    xm_rjl character varying(255),
    lxjccgje character varying(255),
    yjkgsj character varying(255),
    yjjgsj character varying(255),
    sgzb character varying(255),
    jldw character varying(255),
    gc_code character varying(255),
    xm_code character varying(255),
    xm_bh character varying(255),
    bdcdydm character varying(255),
    xmfl character varying(255),
    xzqh character varying(255),
    xm_jd character varying(255),
    xm_wd character varying(255),
    xm_wzgd character varying(255),
    lxwh character varying(255),
    lxjb character varying(255),
    lxpfjg character varying(255),
    lxpfsj timestamp without time zone,
    jsdwtyshxydm character varying(255),
    jsydghxkzbh character varying(255),
    jsgcghxkzbh character varying(255),
    zjly character varying(255),
    gyzjczbl character varying(255),
    ztz character varying(255),
    zmj character varying(255),
    zcd character varying(255),
    sjxz character varying(255),
    gcyt character varying(255),
    xmewm character varying(255),
    sfzdxm character varying(255),
    jhkgsj timestamp without time zone,
    jhjgsj timestamp without time zone,
    jzjnxx character varying(255),
    cxxmxx character varying(255),
    dsjzmj character varying(255),
    dxjzmj character varying(255),
    zdgclx character varying(255),
    sfgkztb character varying(255),
    ghyzzpl character varying(255),
    xmzpt character varying(255),
    xmtb character varying(255),
    xm_jsdw character varying(255),
    xm_jsdw_user character varying(255),
    jsdw_tyshxydm character varying(255)
);


ALTER TABLE test.jck_t_xm_project OWNER TO postgres;

--
-- Name: TABLE jck_t_xm_project; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON TABLE test.jck_t_xm_project IS '数字住建一体化项目信息表';


--
-- Name: COLUMN jck_t_xm_project.gc_xmuuid; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.gc_xmuuid IS '项目uuid';


--
-- Name: COLUMN jck_t_xm_project.gc_xmmc; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.gc_xmmc IS '项目名称';


--
-- Name: COLUMN jck_t_xm_project.gc_xmyt; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.gc_xmyt IS '项目用途';


--
-- Name: COLUMN jck_t_xm_project.gc_xmjsxz; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.gc_xmjsxz IS '建设项目性质';


--
-- Name: COLUMN jck_t_xm_project.gc_xmtzxz; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.gc_xmtzxz IS '项目投资性质A.0.14';


--
-- Name: COLUMN jck_t_xm_project.gc_ztze; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.gc_ztze IS '总投资额';


--
-- Name: COLUMN jck_t_xm_project.gc_zdmj; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.gc_zdmj IS '占地面积';


--
-- Name: COLUMN jck_t_xm_project.gc_jzmj; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.gc_jzmj IS '总建筑面积';


--
-- Name: COLUMN jck_t_xm_project.gc_ssjd; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.gc_ssjd IS '所属街道';


--
-- Name: COLUMN jck_t_xm_project.gc_xmdz; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.gc_xmdz IS '项目地址';


--
-- Name: COLUMN jck_t_xm_project.gc_xmlxrq; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.gc_xmlxrq IS '立项日期';


--
-- Name: COLUMN jck_t_xm_project.create_time; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.create_time IS '创建时间';


--
-- Name: COLUMN jck_t_xm_project.update_time; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.update_time IS '修改时间';


--
-- Name: COLUMN jck_t_xm_project.create_user; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.create_user IS '创建人';


--
-- Name: COLUMN jck_t_xm_project.update_user; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.update_user IS '修改人';


--
-- Name: COLUMN jck_t_xm_project.jsdw_name; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.jsdw_name IS '建设单位';


--
-- Name: COLUMN jck_t_xm_project.xm_status; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.xm_status IS '项目流程转换状态';


--
-- Name: COLUMN jck_t_xm_project.xm_tydm; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.xm_tydm IS '项目统一代码';


--
-- Name: COLUMN jck_t_xm_project.xm_bm; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.xm_bm IS '项目编号';


--
-- Name: COLUMN jck_t_xm_project.xm_gm; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.xm_gm IS '项目规模';


--
-- Name: COLUMN jck_t_xm_project.xm_jsdw_uuid; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.xm_jsdw_uuid IS '建设单位ID';


--
-- Name: COLUMN jck_t_xm_project.xm_xz; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.xm_xz IS '性质，市政，房建，装饰装修';


--
-- Name: COLUMN jck_t_xm_project.xm_dkbh; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.xm_dkbh IS '地块编号';


--
-- Name: COLUMN jck_t_xm_project.xm_rjl; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.xm_rjl IS '容积率';


--
-- Name: COLUMN jck_t_xm_project.lxjccgje; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.lxjccgje IS '绿色建材采购金额（亿元）';


--
-- Name: COLUMN jck_t_xm_project.yjkgsj; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.yjkgsj IS '预计开工时间';


--
-- Name: COLUMN jck_t_xm_project.yjjgsj; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.yjjgsj IS '预计竣工时间';


--
-- Name: COLUMN jck_t_xm_project.sgzb; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.sgzb IS '总包单位';


--
-- Name: COLUMN jck_t_xm_project.jldw; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.jldw IS '监理单位';


--
-- Name: COLUMN jck_t_xm_project.gc_code; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.gc_code IS '工程代码';


--
-- Name: COLUMN jck_t_xm_project.xm_code; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.xm_code IS '系统生成的串联码命名规则为：QD0001';


--
-- Name: COLUMN jck_t_xm_project.xm_bh; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.xm_bh IS '项目编号';


--
-- Name: COLUMN jck_t_xm_project.bdcdydm; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.bdcdydm IS '不动产单元代码（宗地）';


--
-- Name: COLUMN jck_t_xm_project.xmfl; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.xmfl IS '项目分类A.0.25';


--
-- Name: COLUMN jck_t_xm_project.xzqh; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.xzqh IS '行政区划';


--
-- Name: COLUMN jck_t_xm_project.xm_jd; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.xm_jd IS '项目位置经度';


--
-- Name: COLUMN jck_t_xm_project.xm_wd; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.xm_wd IS '项目位置纬度';


--
-- Name: COLUMN jck_t_xm_project.xm_wzgd; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.xm_wzgd IS '项目位置高度';


--
-- Name: COLUMN jck_t_xm_project.lxwh; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.lxwh IS '立项文号';


--
-- Name: COLUMN jck_t_xm_project.lxjb; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.lxjb IS '立项级别A.0.19';


--
-- Name: COLUMN jck_t_xm_project.lxpfjg; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.lxpfjg IS '立项批复机关';


--
-- Name: COLUMN jck_t_xm_project.lxpfsj; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.lxpfsj IS '立项批复时间';


--
-- Name: COLUMN jck_t_xm_project.jsdwtyshxydm; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.jsdwtyshxydm IS '建设单位统一社会信用代码';


--
-- Name: COLUMN jck_t_xm_project.jsydghxkzbh; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.jsydghxkzbh IS '建设用地规划许可证编号';


--
-- Name: COLUMN jck_t_xm_project.jsgcghxkzbh; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.jsgcghxkzbh IS '建设工程规划许可证编号';


--
-- Name: COLUMN jck_t_xm_project.zjly; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.zjly IS '资金来源';


--
-- Name: COLUMN jck_t_xm_project.gyzjczbl; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.gyzjczbl IS '国有资金出资比例';


--
-- Name: COLUMN jck_t_xm_project.ztz; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.ztz IS '总投资（万元）';


--
-- Name: COLUMN jck_t_xm_project.zmj; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.zmj IS '总面积（㎡）';


--
-- Name: COLUMN jck_t_xm_project.zcd; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.zcd IS '总长度（m）';


--
-- Name: COLUMN jck_t_xm_project.sjxz; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.sjxz IS '建设性质';


--
-- Name: COLUMN jck_t_xm_project.gcyt; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.gcyt IS '工程用途';


--
-- Name: COLUMN jck_t_xm_project.xmewm; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.xmewm IS '项目二维码';


--
-- Name: COLUMN jck_t_xm_project.sfzdxm; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.sfzdxm IS '是否重点项目';


--
-- Name: COLUMN jck_t_xm_project.jhkgsj; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.jhkgsj IS '计划开工时间';


--
-- Name: COLUMN jck_t_xm_project.jhjgsj; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.jhjgsj IS '计划竣工时间';


--
-- Name: COLUMN jck_t_xm_project.jzjnxx; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.jzjnxx IS '建筑节能信息';


--
-- Name: COLUMN jck_t_xm_project.cxxmxx; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.cxxmxx IS '超限项目信息';


--
-- Name: COLUMN jck_t_xm_project.dsjzmj; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.dsjzmj IS '地上建筑面积（㎡）';


--
-- Name: COLUMN jck_t_xm_project.dxjzmj; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.dxjzmj IS '地下建筑面积（㎡）';


--
-- Name: COLUMN jck_t_xm_project.zdgclx; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.zdgclx IS '重点工程类型';


--
-- Name: COLUMN jck_t_xm_project.sfgkztb; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.sfgkztb IS '是否公开招投标';


--
-- Name: COLUMN jck_t_xm_project.ghyzzpl; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.ghyzzpl IS '规划预制装配率';


--
-- Name: COLUMN jck_t_xm_project.xmzpt; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.xmzpt IS '项目总平图';


--
-- Name: COLUMN jck_t_xm_project.xmtb; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.xmtb IS '项目图斑';


--
-- Name: COLUMN jck_t_xm_project.xm_jsdw; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.xm_jsdw IS '项目建设单位';


--
-- Name: COLUMN jck_t_xm_project.xm_jsdw_user; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.xm_jsdw_user IS '项目建设单位负责人';


--
-- Name: COLUMN jck_t_xm_project.jsdw_tyshxydm; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.jck_t_xm_project.jsdw_tyshxydm IS '建设单位统一社会信用代码';


--
-- Name: pro_dic_all_data; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.pro_dic_all_data (
    dic_code character varying(100) NOT NULL,
    dict_label character varying(100),
    dict_value character varying(100),
    dict_parent_code character varying(100),
    dict_sort integer,
    dict_status character varying(10),
    create_time timestamp without time zone,
    update_time timestamp without time zone,
    create_user character varying(100),
    update_user character varying(100),
    remark text
);


ALTER TABLE test.pro_dic_all_data OWNER TO postgres;

--
-- Name: TABLE pro_dic_all_data; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON TABLE test.pro_dic_all_data IS '数字住建一体化字典信息表';


--
-- Name: COLUMN pro_dic_all_data.dic_code; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.pro_dic_all_data.dic_code IS '数据id';


--
-- Name: COLUMN pro_dic_all_data.dict_label; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.pro_dic_all_data.dict_label IS '字典文本';


--
-- Name: COLUMN pro_dic_all_data.dict_value; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.pro_dic_all_data.dict_value IS '字典值';


--
-- Name: COLUMN pro_dic_all_data.dict_parent_code; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.pro_dic_all_data.dict_parent_code IS '父级字典';


--
-- Name: COLUMN pro_dic_all_data.dict_sort; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.pro_dic_all_data.dict_sort IS '字典排序';


--
-- Name: COLUMN pro_dic_all_data.dict_status; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.pro_dic_all_data.dict_status IS '状态（0正常 1停用）';


--
-- Name: COLUMN pro_dic_all_data.create_time; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.pro_dic_all_data.create_time IS '创建时间';


--
-- Name: COLUMN pro_dic_all_data.update_time; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.pro_dic_all_data.update_time IS '修改时间';


--
-- Name: COLUMN pro_dic_all_data.create_user; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.pro_dic_all_data.create_user IS '创建人';


--
-- Name: COLUMN pro_dic_all_data.update_user; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.pro_dic_all_data.update_user IS '修改人';


--
-- Name: COLUMN pro_dic_all_data.remark; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.pro_dic_all_data.remark IS '备注';


--
-- Name: t_companyinfo; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.t_companyinfo (
    "F_Id" character varying(50) NOT NULL,
    "F_CompanyName" character varying(300),
    "F_Area" character varying(150),
    "F_Address" character varying(500),
    "F_ContactUser" character varying(50),
    "F_ContactPhone" character varying(50),
    "F_Type" integer,
    "F_ParentId" character varying(50),
    "F_EnabledMark" integer,
    "F_CreatorUserId" character varying(50),
    "F_CreatorTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50),
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteMark" integer,
    "F_SendFlag" integer
);


ALTER TABLE test.t_companyinfo OWNER TO postgres;

--
-- Name: TABLE t_companyinfo; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON TABLE test.t_companyinfo IS '公司基础信息表';


--
-- Name: COLUMN t_companyinfo."F_Id"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_companyinfo."F_Id" IS '主键';


--
-- Name: COLUMN t_companyinfo."F_CompanyName"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_companyinfo."F_CompanyName" IS '公司名称';


--
-- Name: COLUMN t_companyinfo."F_Area"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_companyinfo."F_Area" IS '省市区';


--
-- Name: COLUMN t_companyinfo."F_Address"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_companyinfo."F_Address" IS '地址';


--
-- Name: COLUMN t_companyinfo."F_ContactUser"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_companyinfo."F_ContactUser" IS '联系人';


--
-- Name: COLUMN t_companyinfo."F_ContactPhone"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_companyinfo."F_ContactPhone" IS '手机';


--
-- Name: COLUMN t_companyinfo."F_EnabledMark"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_companyinfo."F_EnabledMark" IS '有效标志';


--
-- Name: COLUMN t_companyinfo."F_CreatorUserId"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_companyinfo."F_CreatorUserId" IS '创建用户';


--
-- Name: COLUMN t_companyinfo."F_CreatorTime"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_companyinfo."F_CreatorTime" IS '创建时间';


--
-- Name: COLUMN t_companyinfo."F_LastModifyUserId"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_companyinfo."F_LastModifyUserId" IS '修改用户';


--
-- Name: COLUMN t_companyinfo."F_LastModifyTime"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_companyinfo."F_LastModifyTime" IS '修改时间';


--
-- Name: COLUMN t_companyinfo."F_DeleteUserId"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_companyinfo."F_DeleteUserId" IS '删除用户';


--
-- Name: COLUMN t_companyinfo."F_DeleteTime"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_companyinfo."F_DeleteTime" IS '删除时间';


--
-- Name: COLUMN t_companyinfo."F_DeleteMark"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_companyinfo."F_DeleteMark" IS '删除标志';


--
-- Name: COLUMN t_companyinfo."F_SendFlag"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_companyinfo."F_SendFlag" IS '发送标记';


--
-- Name: t_message; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.t_message (
    "F_Id" character varying(50) NOT NULL,
    "F_Title" character varying(50),
    "F_ReceiverId" text,
    "F_Content" text,
    "F_Appendix" text,
    "F_Status" integer,
    "F_EnabledMark" integer,
    "F_CreatorUserId" character varying(50),
    "F_CreatorTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50),
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteMark" integer
);


ALTER TABLE test.t_message OWNER TO postgres;

--
-- Name: TABLE t_message; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON TABLE test.t_message IS '消息表';


--
-- Name: COLUMN t_message."F_Id"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_message."F_Id" IS '主键';


--
-- Name: COLUMN t_message."F_ReceiverId"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_message."F_ReceiverId" IS '信息接受人id';


--
-- Name: COLUMN t_message."F_Content"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_message."F_Content" IS '消息内容';


--
-- Name: COLUMN t_message."F_Appendix"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_message."F_Appendix" IS '附件';


--
-- Name: COLUMN t_message."F_Status"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_message."F_Status" IS '邮件状态，0';


--
-- Name: COLUMN t_message."F_EnabledMark"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_message."F_EnabledMark" IS '有效标志';


--
-- Name: COLUMN t_message."F_CreatorUserId"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_message."F_CreatorUserId" IS '创建用户';


--
-- Name: COLUMN t_message."F_CreatorTime"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_message."F_CreatorTime" IS '创建时间';


--
-- Name: COLUMN t_message."F_LastModifyUserId"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_message."F_LastModifyUserId" IS '修改用户';


--
-- Name: COLUMN t_message."F_LastModifyTime"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_message."F_LastModifyTime" IS '修改时间';


--
-- Name: COLUMN t_message."F_DeleteUserId"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_message."F_DeleteUserId" IS '删除用户';


--
-- Name: COLUMN t_message."F_DeleteTime"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_message."F_DeleteTime" IS '删除时间';


--
-- Name: COLUMN t_message."F_DeleteMark"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_message."F_DeleteMark" IS '删除标识';


--
-- Name: t_product_relation; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.t_product_relation (
    "F_Id" character varying(50) NOT NULL,
    "F_ProductId" character varying(50),
    "F_CheckProductId" character varying(50),
    "F_Status" integer
);


ALTER TABLE test.t_product_relation OWNER TO postgres;

--
-- Name: t_project; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.t_project (
    "F_Id" character varying(50) NOT NULL,
    "F_ConstructionPermitNo" character varying(200),
    "F_ConstructionPermitDate" timestamp without time zone,
    "F_ProjectName" character varying(300),
    "F_ProjectProperties" character varying(50),
    "F_Floorage" double precision,
    "F_ProjectProgress" character varying(50),
    "F_ProjectAddress" character varying(200),
    "F_ProjectStructureType" character varying(50),
    "F_SupervisionOrganization" character varying(50),
    "F_ConstrctionUnitId" character varying(50),
    "F_ConstrctionUnitLeader" character varying(50),
    "F_ConstrctionUnitLeaderPhone" character varying(50),
    "F_Remark" text,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteMark" integer,
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50),
    "F_EnabledMark" integer,
    "F_GldProjectId" character varying(50),
    "F_DigitalPlatCode" character varying(255)
);


ALTER TABLE test.t_project OWNER TO postgres;

--
-- Name: COLUMN t_project."F_Id"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project."F_Id" IS '主键';


--
-- Name: COLUMN t_project."F_ConstructionPermitNo"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project."F_ConstructionPermitNo" IS '施工许可证';


--
-- Name: COLUMN t_project."F_ConstructionPermitDate"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project."F_ConstructionPermitDate" IS '施工许可发证日期';


--
-- Name: COLUMN t_project."F_ProjectName"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project."F_ProjectName" IS '工程名称';


--
-- Name: COLUMN t_project."F_ProjectProperties"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project."F_ProjectProperties" IS '工程性质';


--
-- Name: COLUMN t_project."F_Floorage"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project."F_Floorage" IS '建筑面积';


--
-- Name: COLUMN t_project."F_ProjectProgress"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project."F_ProjectProgress" IS '工程进度';


--
-- Name: COLUMN t_project."F_ProjectAddress"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project."F_ProjectAddress" IS '工程地址';


--
-- Name: COLUMN t_project."F_ProjectStructureType"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project."F_ProjectStructureType" IS '工程结构型式';


--
-- Name: COLUMN t_project."F_SupervisionOrganization"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project."F_SupervisionOrganization" IS '质量监督机构';


--
-- Name: COLUMN t_project."F_ConstrctionUnitId"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project."F_ConstrctionUnitId" IS '施工单位';


--
-- Name: COLUMN t_project."F_ConstrctionUnitLeader"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project."F_ConstrctionUnitLeader" IS '施工单位负责人';


--
-- Name: COLUMN t_project."F_ConstrctionUnitLeaderPhone"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project."F_ConstrctionUnitLeaderPhone" IS '施工单位负责人联系方式';


--
-- Name: COLUMN t_project."F_Remark"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project."F_Remark" IS '备注';


--
-- Name: COLUMN t_project."F_DigitalPlatCode"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project."F_DigitalPlatCode" IS '数字住建一体化平台编码';


--
-- Name: t_project_product; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.t_project_product (
    "F_Id" character varying(50) NOT NULL,
    "F_ProjectId" character varying(50),
    "F_ProductType" character varying(100),
    "F_ProductName" character varying(50),
    "F_ProductStandardSelect" text,
    "F_ProductStandard" character varying(100),
    "F_ProcuringEntity" character varying(50),
    "F_ManufacturerId" character varying(50),
    "F_SupplierId" character varying(50),
    "F_Seller" character varying(200),
    "F_Address" character varying(200),
    "F_Quantity" double precision,
    "F_Unit" character varying(50),
    "F_RecordNo" character varying(50),
    "F_BatchDate" timestamp without time zone,
    "F_BatchNo" character varying(50),
    "F_UnitPrice" double precision,
    "F_ApproachTime" timestamp without time zone,
    "F_FillingTime" timestamp without time zone,
    "F_CheckStatus" integer,
    "F_SupplierCheckStatus" integer,
    "F_CheckOutTime" integer,
    "F_CheckFirstFailReason" character varying(50),
    "F_CheckSecondFailReason" character varying(50),
    "F_CheckFirstFailRemark" text,
    "F_CheckSecondFailRemark" text,
    "F_SupplierCheckFirstFailReason" character varying(50),
    "F_SupplierCheckSecondFailReason" character varying(50),
    "F_SupplierCheckFirstFailRemark" text,
    "F_SupplierCheckSecondFailRemark" text,
    "F_Certificate" text,
    "F_InspectionReport" text,
    "F_PerformanceTestReport" text,
    "F_PhysicalPhoto" text,
    "F_IsPassByRequest" integer,
    "F_SortCode" bigint,
    "F_JlUnit" character varying(200),
    "F_PassReason" character varying(500),
    "F_JlUnitCheckTime" timestamp without time zone,
    "F_EnabledMark" integer,
    "F_CreatorUserId" character varying(50),
    "F_CreatorTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50),
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteMark" integer,
    "F_ProjectProgress" character varying(50),
    "F_SendFlag" integer,
    "F_FileUrl" character varying(500),
    "F_HasRecordNo" integer
);


ALTER TABLE test.t_project_product OWNER TO postgres;

--
-- Name: TABLE t_project_product; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON TABLE test.t_project_product IS '工程产品管理信息表';


--
-- Name: COLUMN t_project_product."F_Id"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project_product."F_Id" IS '主键';


--
-- Name: COLUMN t_project_product."F_ProjectId"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project_product."F_ProjectId" IS '工程id';


--
-- Name: COLUMN t_project_product."F_ProductType"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project_product."F_ProductType" IS '产品类别';


--
-- Name: COLUMN t_project_product."F_ProductName"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project_product."F_ProductName" IS '产品名称';


--
-- Name: COLUMN t_project_product."F_ProductStandard"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project_product."F_ProductStandard" IS '产品规格';


--
-- Name: COLUMN t_project_product."F_ProcuringEntity"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project_product."F_ProcuringEntity" IS '采购主体';


--
-- Name: COLUMN t_project_product."F_ManufacturerId"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project_product."F_ManufacturerId" IS '生产单位名称';


--
-- Name: COLUMN t_project_product."F_Address"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project_product."F_Address" IS '生产单位详细地址';


--
-- Name: COLUMN t_project_product."F_Quantity"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project_product."F_Quantity" IS '采购数量';


--
-- Name: COLUMN t_project_product."F_Unit"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project_product."F_Unit" IS '采购单位';


--
-- Name: COLUMN t_project_product."F_RecordNo"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project_product."F_RecordNo" IS '备案证号';


--
-- Name: COLUMN t_project_product."F_BatchDate"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project_product."F_BatchDate" IS '生产日期';


--
-- Name: COLUMN t_project_product."F_BatchNo"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project_product."F_BatchNo" IS '生产批号';


--
-- Name: COLUMN t_project_product."F_UnitPrice"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project_product."F_UnitPrice" IS '采购单价';


--
-- Name: COLUMN t_project_product."F_ApproachTime"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project_product."F_ApproachTime" IS '进场时间';


--
-- Name: COLUMN t_project_product."F_FillingTime"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project_product."F_FillingTime" IS '填报时间';


--
-- Name: COLUMN t_project_product."F_CheckStatus"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project_product."F_CheckStatus" IS '审核是否通过';


--
-- Name: COLUMN t_project_product."F_SortCode"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project_product."F_SortCode" IS '排序码';


--
-- Name: COLUMN t_project_product."F_EnabledMark"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project_product."F_EnabledMark" IS '有效标志';


--
-- Name: COLUMN t_project_product."F_CreatorUserId"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project_product."F_CreatorUserId" IS '创建用户';


--
-- Name: COLUMN t_project_product."F_CreatorTime"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project_product."F_CreatorTime" IS '创建时间';


--
-- Name: COLUMN t_project_product."F_LastModifyUserId"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project_product."F_LastModifyUserId" IS '修改用户';


--
-- Name: COLUMN t_project_product."F_LastModifyTime"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project_product."F_LastModifyTime" IS '修改时间';


--
-- Name: COLUMN t_project_product."F_DeleteUserId"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project_product."F_DeleteUserId" IS '删除用户';


--
-- Name: COLUMN t_project_product."F_DeleteTime"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_project_product."F_DeleteTime" IS '删除时间';


--
-- Name: t_quality_trace; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.t_quality_trace (
    "F_Id" character varying(50) NOT NULL,
    "F_OriginalId" character varying(50),
    "F_CheckOrganize" character varying(200),
    "F_ProjectNo" character varying(200),
    "F_ProjectName" character varying(500),
    "F_ProductName" character varying(500),
    "F_FactoryName" character varying(500),
    "F_Batch" character varying(100),
    "F_CheckProjectName" character varying(800),
    "F_DataStatus" character varying(1),
    "F_IsCollect" character varying(1),
    "F_ConclusionMark" character varying(50),
    "F_Conclusion" character varying(500),
    "F_ReportTime" timestamp without time zone,
    "F_CheckTime" timestamp without time zone,
    "F_EnabledMark" integer,
    "F_CreatorUserId" character varying(50),
    "F_CreatorTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50),
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteMark" integer
);


ALTER TABLE test.t_quality_trace OWNER TO postgres;

--
-- Name: TABLE t_quality_trace; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON TABLE test.t_quality_trace IS '数据同步表';


--
-- Name: COLUMN t_quality_trace."F_Id"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_quality_trace."F_Id" IS '主键';


--
-- Name: COLUMN t_quality_trace."F_ProjectNo"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_quality_trace."F_ProjectNo" IS '工程编号';


--
-- Name: COLUMN t_quality_trace."F_ProjectName"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_quality_trace."F_ProjectName" IS '工程名称';


--
-- Name: COLUMN t_quality_trace."F_ProductName"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_quality_trace."F_ProductName" IS '检验产品名称';


--
-- Name: COLUMN t_quality_trace."F_FactoryName"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_quality_trace."F_FactoryName" IS '生产单位名称';


--
-- Name: COLUMN t_quality_trace."F_Batch"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_quality_trace."F_Batch" IS '批号';


--
-- Name: COLUMN t_quality_trace."F_CheckProjectName"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_quality_trace."F_CheckProjectName" IS '监察项目名称';


--
-- Name: COLUMN t_quality_trace."F_DataStatus"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_quality_trace."F_DataStatus" IS '数据状态';


--
-- Name: COLUMN t_quality_trace."F_IsCollect"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_quality_trace."F_IsCollect" IS '是否已经采集';


--
-- Name: COLUMN t_quality_trace."F_ConclusionMark"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_quality_trace."F_ConclusionMark" IS '结论标志';


--
-- Name: COLUMN t_quality_trace."F_Conclusion"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_quality_trace."F_Conclusion" IS '结论';


--
-- Name: COLUMN t_quality_trace."F_ReportTime"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_quality_trace."F_ReportTime" IS '报告日期';


--
-- Name: COLUMN t_quality_trace."F_EnabledMark"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_quality_trace."F_EnabledMark" IS '有效标志';


--
-- Name: COLUMN t_quality_trace."F_CreatorUserId"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_quality_trace."F_CreatorUserId" IS '创建用户';


--
-- Name: COLUMN t_quality_trace."F_CreatorTime"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_quality_trace."F_CreatorTime" IS '创建时间';


--
-- Name: COLUMN t_quality_trace."F_LastModifyUserId"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_quality_trace."F_LastModifyUserId" IS '修改用户';


--
-- Name: COLUMN t_quality_trace."F_LastModifyTime"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_quality_trace."F_LastModifyTime" IS '修改时间';


--
-- Name: COLUMN t_quality_trace."F_DeleteUserId"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_quality_trace."F_DeleteUserId" IS '删除用户';


--
-- Name: COLUMN t_quality_trace."F_DeleteTime"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_quality_trace."F_DeleteTime" IS '删除时间';


--
-- Name: COLUMN t_quality_trace."F_DeleteMark"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_quality_trace."F_DeleteMark" IS '删除标志';


--
-- Name: t_record_product; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.t_record_product (
    "F_Id" character varying(50) NOT NULL,
    "F_RecordProductName" character varying(2000),
    "F_Manufactor" character varying(500),
    "F_RecordNo" character varying(200),
    "F_BeginTime" timestamp without time zone,
    "F_EndTime" timestamp without time zone,
    "F_EnabledMark" integer,
    "F_CreatorTime" timestamp without time zone,
    "F_CreatorUserId" character varying(50),
    "F_LastModifyTime" timestamp without time zone,
    "F_LastModifyUserId" character varying(50),
    "F_DeleteMark" integer,
    "F_DeleteTime" timestamp without time zone,
    "F_DeleteUserId" character varying(50),
    "F_SendFlag" integer,
    "F_SocialCreditCode" character varying(255)
);


ALTER TABLE test.t_record_product OWNER TO postgres;

--
-- Name: TABLE t_record_product; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON TABLE test.t_record_product IS '备案产品管理表';


--
-- Name: COLUMN t_record_product."F_Id"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_record_product."F_Id" IS '主键';


--
-- Name: COLUMN t_record_product."F_RecordProductName"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_record_product."F_RecordProductName" IS '备案产品名称';


--
-- Name: COLUMN t_record_product."F_Manufactor"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_record_product."F_Manufactor" IS '生产厂家';


--
-- Name: COLUMN t_record_product."F_RecordNo"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_record_product."F_RecordNo" IS '备案证号';


--
-- Name: COLUMN t_record_product."F_BeginTime"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_record_product."F_BeginTime" IS '备案证有效开始时间';


--
-- Name: COLUMN t_record_product."F_EndTime"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_record_product."F_EndTime" IS '备案证有效结束时间';


--
-- Name: COLUMN t_record_product."F_EnabledMark"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_record_product."F_EnabledMark" IS '是否可用';


--
-- Name: COLUMN t_record_product."F_CreatorTime"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_record_product."F_CreatorTime" IS '创建时间';


--
-- Name: COLUMN t_record_product."F_CreatorUserId"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_record_product."F_CreatorUserId" IS '创建人';


--
-- Name: COLUMN t_record_product."F_LastModifyTime"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_record_product."F_LastModifyTime" IS '修改时间';


--
-- Name: COLUMN t_record_product."F_LastModifyUserId"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_record_product."F_LastModifyUserId" IS '修改人';


--
-- Name: COLUMN t_record_product."F_DeleteMark"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_record_product."F_DeleteMark" IS '删除标志';


--
-- Name: COLUMN t_record_product."F_DeleteTime"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_record_product."F_DeleteTime" IS '删除日期';


--
-- Name: COLUMN t_record_product."F_DeleteUserId"; Type: COMMENT; Schema: test; Owner: postgres
--

COMMENT ON COLUMN test.t_record_product."F_DeleteUserId" IS '删除人';


--
-- PostgreSQL database dump complete
--

\unrestrict 5szZlKjsafTztVKL3CRuGqS5XVAR7iLwSCdkig9hZJq4sFcrUHxhc991t3UMnFd

