--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE accounts (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    owner_id integer
);


--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE accounts_id_seq OWNED BY accounts.id;


--
-- Name: admins; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE admins (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    confirmation_token character varying(255),
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    first_name character varying,
    last_name character varying,
    authy_id character varying,
    last_sign_in_with_authy timestamp without time zone,
    authy_enabled boolean DEFAULT false,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp without time zone
);


--
-- Name: admins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE admins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE admins_id_seq OWNED BY admins.id;


--
-- Name: assessor_assignments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE assessor_assignments (
    id integer NOT NULL,
    form_answer_id integer NOT NULL,
    assessor_id integer,
    "position" integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    document hstore,
    submitted_at timestamp without time zone,
    editable_type character varying,
    editable_id integer,
    assessed_at timestamp without time zone,
    locked_at timestamp without time zone
);


--
-- Name: assessor_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assessor_assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assessor_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE assessor_assignments_id_seq OWNED BY assessor_assignments.id;


--
-- Name: assessors; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE assessors (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    first_name character varying,
    last_name character varying,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    trade_role character varying,
    innovation_role character varying,
    development_role character varying,
    promotion_role character varying,
    telephone_number character varying,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp without time zone,
    company character varying
);


--
-- Name: assessors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assessors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assessors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE assessors_id_seq OWNED BY assessors.id;


--
-- Name: audit_certificates; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE audit_certificates (
    id integer NOT NULL,
    form_answer_id integer NOT NULL,
    attachment character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    changes_description text,
    reviewable_type character varying,
    reviewable_id integer,
    reviewed_at timestamp without time zone,
    status integer
);


--
-- Name: audit_certificates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE audit_certificates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audit_certificates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE audit_certificates_id_seq OWNED BY audit_certificates.id;


--
-- Name: award_years; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE award_years (
    id integer NOT NULL,
    year integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: award_years_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE award_years_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: award_years_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE award_years_id_seq OWNED BY award_years.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE comments (
    id integer NOT NULL,
    commentable_id integer NOT NULL,
    commentable_type character varying NOT NULL,
    body text NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    authorable_type character varying NOT NULL,
    authorable_id integer NOT NULL,
    section integer NOT NULL,
    flagged boolean DEFAULT false
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comments_id_seq OWNED BY comments.id;


--
-- Name: deadlines; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE deadlines (
    id integer NOT NULL,
    kind character varying,
    trigger_at timestamp without time zone,
    settings_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    states_triggered_at timestamp without time zone
);


--
-- Name: deadlines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE deadlines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: deadlines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE deadlines_id_seq OWNED BY deadlines.id;


--
-- Name: draft_notes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE draft_notes (
    id integer NOT NULL,
    content text,
    notable_type character varying NOT NULL,
    notable_id integer NOT NULL,
    authorable_type character varying NOT NULL,
    authorable_id integer NOT NULL,
    content_updated_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: draft_notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE draft_notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: draft_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE draft_notes_id_seq OWNED BY draft_notes.id;


--
-- Name: eligibilities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE eligibilities (
    id integer NOT NULL,
    account_id integer,
    answers hstore,
    passed boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    type character varying,
    form_answer_id integer
);


--
-- Name: eligibilities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE eligibilities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: eligibilities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE eligibilities_id_seq OWNED BY eligibilities.id;


--
-- Name: email_notifications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE email_notifications (
    id integer NOT NULL,
    kind character varying,
    sent boolean,
    trigger_at timestamp without time zone,
    settings_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: email_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE email_notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: email_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE email_notifications_id_seq OWNED BY email_notifications.id;


--
-- Name: feedbacks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE feedbacks (
    id integer NOT NULL,
    form_answer_id integer,
    submitted boolean DEFAULT false,
    approved boolean DEFAULT false,
    document hstore,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    authorable_type character varying,
    authorable_id integer,
    locked_at timestamp without time zone
);


--
-- Name: feedbacks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE feedbacks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feedbacks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE feedbacks_id_seq OWNED BY feedbacks.id;


--
-- Name: form_answer_attachments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE form_answer_attachments (
    id integer NOT NULL,
    form_answer_id integer,
    file text,
    original_filename text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    attachable_id integer,
    attachable_type character varying,
    title character varying,
    restricted_to_admin boolean DEFAULT false,
    question_key character varying
);


--
-- Name: form_answer_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE form_answer_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: form_answer_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE form_answer_attachments_id_seq OWNED BY form_answer_attachments.id;


--
-- Name: form_answer_progresses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE form_answer_progresses (
    id integer NOT NULL,
    sections hstore,
    form_answer_id integer NOT NULL
);


--
-- Name: form_answer_progresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE form_answer_progresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: form_answer_progresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE form_answer_progresses_id_seq OWNED BY form_answer_progresses.id;


--
-- Name: form_answer_transitions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE form_answer_transitions (
    id integer NOT NULL,
    to_state character varying NOT NULL,
    metadata text DEFAULT '{}'::text,
    sort_key integer NOT NULL,
    form_answer_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: form_answer_transitions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE form_answer_transitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: form_answer_transitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE form_answer_transitions_id_seq OWNED BY form_answer_transitions.id;


--
-- Name: form_answers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE form_answers (
    id integer NOT NULL,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    award_type character varying,
    account_id integer,
    urn character varying,
    submitted boolean DEFAULT false,
    fill_progress double precision,
    state character varying DEFAULT 'eligibility_in_progress'::character varying NOT NULL,
    company_or_nominee_name character varying,
    nominee_full_name character varying,
    user_full_name character varying,
    award_type_full_name character varying,
    sic_code character varying,
    nickname character varying,
    financial_data hstore,
    accepted boolean DEFAULT false,
    company_details_updated_at timestamp without time zone,
    award_year_id integer NOT NULL,
    company_details_editable_id integer,
    company_details_editable_type character varying,
    primary_assessor_id integer,
    secondary_assessor_id integer,
    document json,
    nominee_title character varying,
    nominator_full_name character varying,
    nominator_email character varying,
    user_email character varying,
    corp_responsibility_reviewed boolean DEFAULT false,
    pdf_version character varying
);


--
-- Name: form_answers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE form_answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: form_answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE form_answers_id_seq OWNED BY form_answers.id;


--
-- Name: palace_attendees; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE palace_attendees (
    id integer NOT NULL,
    title character varying,
    first_name character varying,
    last_name character varying,
    job_name character varying,
    post_nominals character varying,
    address_1 character varying,
    address_2 character varying,
    address_3 character varying,
    address_4 character varying,
    postcode character varying,
    phone_number character varying,
    product_description character varying,
    additional_info text,
    palace_invite_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: palace_attendees_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE palace_attendees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: palace_attendees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE palace_attendees_id_seq OWNED BY palace_attendees.id;


--
-- Name: palace_invites; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE palace_invites (
    id integer NOT NULL,
    email character varying,
    form_answer_id integer,
    token character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: palace_invites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE palace_invites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: palace_invites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE palace_invites_id_seq OWNED BY palace_invites.id;


--
-- Name: press_summaries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE press_summaries (
    id integer NOT NULL,
    form_answer_id integer NOT NULL,
    body text,
    comment text,
    approved boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying,
    email character varying,
    phone_number character varying,
    correct boolean,
    reviewed_by_user boolean DEFAULT false,
    token character varying,
    authorable_type character varying,
    authorable_id integer,
    submitted boolean DEFAULT false
);


--
-- Name: press_summaries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE press_summaries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: press_summaries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE press_summaries_id_seq OWNED BY press_summaries.id;


--
-- Name: previous_wins; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE previous_wins (
    id integer NOT NULL,
    form_answer_id integer NOT NULL,
    category character varying,
    year integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: previous_wins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE previous_wins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: previous_wins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE previous_wins_id_seq OWNED BY previous_wins.id;


--
-- Name: scans; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE scans (
    id integer NOT NULL,
    uuid character varying NOT NULL,
    filename character varying,
    status character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    form_answer_attachment_id integer,
    support_letter_attachment_id integer,
    audit_certificate_id integer,
    vs_id character varying
);


--
-- Name: scans_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE scans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: scans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE scans_id_seq OWNED BY scans.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: settings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE settings (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    award_year_id integer NOT NULL
);


--
-- Name: settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE settings_id_seq OWNED BY settings.id;


--
-- Name: site_feedbacks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE site_feedbacks (
    id integer NOT NULL,
    rating integer,
    comment text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: site_feedbacks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE site_feedbacks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: site_feedbacks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE site_feedbacks_id_seq OWNED BY site_feedbacks.id;


--
-- Name: support_letter_attachments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE support_letter_attachments (
    id integer NOT NULL,
    user_id integer NOT NULL,
    form_answer_id integer NOT NULL,
    attachment character varying,
    original_filename character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    support_letter_id integer
);


--
-- Name: support_letter_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE support_letter_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: support_letter_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE support_letter_attachments_id_seq OWNED BY support_letter_attachments.id;


--
-- Name: support_letters; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE support_letters (
    id integer NOT NULL,
    supporter_id integer,
    body text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    user_id integer,
    form_answer_id integer,
    first_name character varying,
    last_name character varying,
    organization_name character varying,
    phone character varying,
    relationship_to_nominee character varying,
    address_first character varying,
    address_second character varying,
    city character varying,
    country character varying,
    postcode character varying,
    manual boolean DEFAULT false
);


--
-- Name: support_letters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE support_letters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: support_letters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE support_letters_id_seq OWNED BY support_letters.id;


--
-- Name: supporters; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE supporters (
    id integer NOT NULL,
    form_answer_id integer,
    email character varying,
    access_key character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    user_id integer,
    first_name character varying,
    last_name character varying,
    relationship_to_nominee character varying
);


--
-- Name: supporters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE supporters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: supporters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE supporters_id_seq OWNED BY supporters.id;


--
-- Name: urn_seq_2015; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2015
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2016; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2016
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2017; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2017
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2018; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2018
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2019; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2019
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2020; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2020
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2021; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2021
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2022; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2022
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2023; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2023
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2024; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2024
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2025; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2025
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2026; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2026
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2027; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2027
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2028; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2028
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2029; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2029
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2030; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2030
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2031; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2031
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2032; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2032
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2033; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2033
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2034; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2034
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2035; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2035
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2036; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2036
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2037; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2037
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2038; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2038
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2039; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2039
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2040; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2040
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2041; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2041
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2042; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2042
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2043; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2043
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2044; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2044
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2045; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2045
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2046; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2046
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2047; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2047
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2048; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2048
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2049; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2049
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2050; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2050
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2051; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2051
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2052; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2052
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2053; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2053
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2054; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2054
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2055; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2055
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2056; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2056
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2057; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2057
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2058; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2058
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2059; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2059
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2060; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2060
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2061; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2061
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2062; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2062
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2063; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2063
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2064; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2064
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_2065; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_2065
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2015; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2015
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2016; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2016
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2017; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2017
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2018; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2018
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2019; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2019
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2020; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2020
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2021; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2021
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2022; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2022
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2023; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2023
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2024; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2024
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2025; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2025
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2026; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2026
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2027; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2027
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2028; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2028
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2029; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2029
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2030; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2030
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2031; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2031
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2032; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2032
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2033; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2033
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2034; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2034
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2035; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2035
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2036; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2036
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2037; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2037
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2038; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2038
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2039; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2039
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2040; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2040
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2041; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2041
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2042; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2042
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2043; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2043
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2044; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2044
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2045; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2045
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2046; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2046
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2047; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2047
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2048; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2048
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2049; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2049
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2050; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2050
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2051; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2051
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2052; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2052
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2053; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2053
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2054; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2054
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2055; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2055
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2056; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2056
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2057; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2057
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2058; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2058
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2059; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2059
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2060; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2060
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2061; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2061
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2062; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2062
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2063; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2063
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2064; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2064
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urn_seq_promotion_2065; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urn_seq_promotion_2065
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    title character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    job_title character varying(255),
    phone_number character varying(255),
    company_name character varying(255),
    company_address_first character varying(255),
    company_address_second character varying(255),
    company_city character varying(255),
    company_country character varying(255),
    company_postcode character varying(255),
    company_phone_number character varying(255),
    prefered_method_of_contact character varying(255),
    subscribed_to_emails boolean DEFAULT false,
    qae_info_source character varying(255),
    qae_info_source_other character varying(255),
    completed_registration boolean DEFAULT false,
    account_id integer,
    role character varying,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    agree_being_contacted_by_department_of_business boolean DEFAULT false,
    imported boolean DEFAULT false,
    address_line1 character varying,
    address_line2 character varying,
    address_line3 character varying,
    postcode character varying,
    phone_number2 character varying,
    mobile_number character varying,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp without time zone
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: version_associations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE version_associations (
    id integer NOT NULL,
    version_id integer,
    foreign_key_name character varying NOT NULL,
    foreign_key_id integer
);


--
-- Name: version_associations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE version_associations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: version_associations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE version_associations_id_seq OWNED BY version_associations.id;


--
-- Name: versions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE versions (
    id integer NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object json,
    object_changes json,
    created_at timestamp without time zone,
    transaction_id integer
);


--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE versions_id_seq OWNED BY versions.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts ALTER COLUMN id SET DEFAULT nextval('accounts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY admins ALTER COLUMN id SET DEFAULT nextval('admins_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY assessor_assignments ALTER COLUMN id SET DEFAULT nextval('assessor_assignments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY assessors ALTER COLUMN id SET DEFAULT nextval('assessors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY audit_certificates ALTER COLUMN id SET DEFAULT nextval('audit_certificates_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY award_years ALTER COLUMN id SET DEFAULT nextval('award_years_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments ALTER COLUMN id SET DEFAULT nextval('comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY deadlines ALTER COLUMN id SET DEFAULT nextval('deadlines_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY draft_notes ALTER COLUMN id SET DEFAULT nextval('draft_notes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY eligibilities ALTER COLUMN id SET DEFAULT nextval('eligibilities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY email_notifications ALTER COLUMN id SET DEFAULT nextval('email_notifications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY feedbacks ALTER COLUMN id SET DEFAULT nextval('feedbacks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY form_answer_attachments ALTER COLUMN id SET DEFAULT nextval('form_answer_attachments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY form_answer_progresses ALTER COLUMN id SET DEFAULT nextval('form_answer_progresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY form_answer_transitions ALTER COLUMN id SET DEFAULT nextval('form_answer_transitions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY form_answers ALTER COLUMN id SET DEFAULT nextval('form_answers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY palace_attendees ALTER COLUMN id SET DEFAULT nextval('palace_attendees_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY palace_invites ALTER COLUMN id SET DEFAULT nextval('palace_invites_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY press_summaries ALTER COLUMN id SET DEFAULT nextval('press_summaries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY previous_wins ALTER COLUMN id SET DEFAULT nextval('previous_wins_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY scans ALTER COLUMN id SET DEFAULT nextval('scans_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY settings ALTER COLUMN id SET DEFAULT nextval('settings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY site_feedbacks ALTER COLUMN id SET DEFAULT nextval('site_feedbacks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY support_letter_attachments ALTER COLUMN id SET DEFAULT nextval('support_letter_attachments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY support_letters ALTER COLUMN id SET DEFAULT nextval('support_letters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY supporters ALTER COLUMN id SET DEFAULT nextval('supporters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY version_associations ALTER COLUMN id SET DEFAULT nextval('version_associations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY versions ALTER COLUMN id SET DEFAULT nextval('versions_id_seq'::regclass);


--
-- Name: accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: admins_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- Name: assessor_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assessor_assignments
    ADD CONSTRAINT assessor_assignments_pkey PRIMARY KEY (id);


--
-- Name: assessors_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assessors
    ADD CONSTRAINT assessors_pkey PRIMARY KEY (id);


--
-- Name: audit_certificates_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY audit_certificates
    ADD CONSTRAINT audit_certificates_pkey PRIMARY KEY (id);


--
-- Name: award_years_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY award_years
    ADD CONSTRAINT award_years_pkey PRIMARY KEY (id);


--
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: deadlines_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY deadlines
    ADD CONSTRAINT deadlines_pkey PRIMARY KEY (id);


--
-- Name: draft_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY draft_notes
    ADD CONSTRAINT draft_notes_pkey PRIMARY KEY (id);


--
-- Name: eligibilities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY eligibilities
    ADD CONSTRAINT eligibilities_pkey PRIMARY KEY (id);


--
-- Name: email_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY email_notifications
    ADD CONSTRAINT email_notifications_pkey PRIMARY KEY (id);


--
-- Name: feedbacks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY feedbacks
    ADD CONSTRAINT feedbacks_pkey PRIMARY KEY (id);


--
-- Name: form_answer_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY form_answer_attachments
    ADD CONSTRAINT form_answer_attachments_pkey PRIMARY KEY (id);


--
-- Name: form_answer_progresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY form_answer_progresses
    ADD CONSTRAINT form_answer_progresses_pkey PRIMARY KEY (id);


--
-- Name: form_answer_transitions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY form_answer_transitions
    ADD CONSTRAINT form_answer_transitions_pkey PRIMARY KEY (id);


--
-- Name: form_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY form_answers
    ADD CONSTRAINT form_answers_pkey PRIMARY KEY (id);


--
-- Name: palace_attendees_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY palace_attendees
    ADD CONSTRAINT palace_attendees_pkey PRIMARY KEY (id);


--
-- Name: palace_invites_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY palace_invites
    ADD CONSTRAINT palace_invites_pkey PRIMARY KEY (id);


--
-- Name: press_summaries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY press_summaries
    ADD CONSTRAINT press_summaries_pkey PRIMARY KEY (id);


--
-- Name: previous_wins_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY previous_wins
    ADD CONSTRAINT previous_wins_pkey PRIMARY KEY (id);


--
-- Name: scans_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY scans
    ADD CONSTRAINT scans_pkey PRIMARY KEY (id);


--
-- Name: settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


--
-- Name: site_feedbacks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY site_feedbacks
    ADD CONSTRAINT site_feedbacks_pkey PRIMARY KEY (id);


--
-- Name: support_letter_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY support_letter_attachments
    ADD CONSTRAINT support_letter_attachments_pkey PRIMARY KEY (id);


--
-- Name: support_letters_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY support_letters
    ADD CONSTRAINT support_letters_pkey PRIMARY KEY (id);


--
-- Name: supporters_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY supporters
    ADD CONSTRAINT supporters_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: version_associations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY version_associations
    ADD CONSTRAINT version_associations_pkey PRIMARY KEY (id);


--
-- Name: versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: index_accounts_on_owner_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_accounts_on_owner_id ON accounts USING btree (owner_id);


--
-- Name: index_admins_on_authy_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_admins_on_authy_id ON admins USING btree (authy_id);


--
-- Name: index_admins_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admins_on_email ON admins USING btree (email);


--
-- Name: index_admins_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admins_on_reset_password_token ON admins USING btree (reset_password_token);


--
-- Name: index_admins_on_unlock_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admins_on_unlock_token ON admins USING btree (unlock_token);


--
-- Name: index_assessor_assignments_on_assessor_id_and_form_answer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_assessor_assignments_on_assessor_id_and_form_answer_id ON assessor_assignments USING btree (assessor_id, form_answer_id);


--
-- Name: index_assessor_assignments_on_form_answer_id_and_position; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_assessor_assignments_on_form_answer_id_and_position ON assessor_assignments USING btree (form_answer_id, "position");


--
-- Name: index_assessors_on_confirmation_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_assessors_on_confirmation_token ON assessors USING btree (confirmation_token);


--
-- Name: index_assessors_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_assessors_on_email ON assessors USING btree (email);


--
-- Name: index_assessors_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_assessors_on_reset_password_token ON assessors USING btree (reset_password_token);


--
-- Name: index_assessors_on_unlock_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_assessors_on_unlock_token ON assessors USING btree (unlock_token);


--
-- Name: index_audit_certificates_on_form_answer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_audit_certificates_on_form_answer_id ON audit_certificates USING btree (form_answer_id);


--
-- Name: index_award_years_on_year; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_award_years_on_year ON award_years USING btree (year);


--
-- Name: index_comments_on_commentable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_commentable_id ON comments USING btree (commentable_id);


--
-- Name: index_comments_on_commentable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_commentable_type ON comments USING btree (commentable_type);


--
-- Name: index_deadlines_on_settings_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_deadlines_on_settings_id ON deadlines USING btree (settings_id);


--
-- Name: index_eligibilities_on_account_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_eligibilities_on_account_id ON eligibilities USING btree (account_id);


--
-- Name: index_eligibilities_on_form_answer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_eligibilities_on_form_answer_id ON eligibilities USING btree (form_answer_id);


--
-- Name: index_email_notifications_on_settings_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_email_notifications_on_settings_id ON email_notifications USING btree (settings_id);


--
-- Name: index_feedbacks_on_form_answer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_feedbacks_on_form_answer_id ON feedbacks USING btree (form_answer_id);


--
-- Name: index_form_answer_attachments_on_form_answer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_form_answer_attachments_on_form_answer_id ON form_answer_attachments USING btree (form_answer_id);


--
-- Name: index_form_answer_progresses_on_form_answer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_form_answer_progresses_on_form_answer_id ON form_answer_progresses USING btree (form_answer_id);


--
-- Name: index_form_answer_transitions_on_form_answer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_form_answer_transitions_on_form_answer_id ON form_answer_transitions USING btree (form_answer_id);


--
-- Name: index_form_answer_transitions_on_sort_key_and_form_answer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_form_answer_transitions_on_sort_key_and_form_answer_id ON form_answer_transitions USING btree (sort_key, form_answer_id);


--
-- Name: index_form_answers_on_account_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_form_answers_on_account_id ON form_answers USING btree (account_id);


--
-- Name: index_form_answers_on_award_year_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_form_answers_on_award_year_id ON form_answers USING btree (award_year_id);


--
-- Name: index_form_answers_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_form_answers_on_user_id ON form_answers USING btree (user_id);


--
-- Name: index_palace_attendees_on_palace_invite_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_palace_attendees_on_palace_invite_id ON palace_attendees USING btree (palace_invite_id);


--
-- Name: index_palace_invites_on_form_answer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_palace_invites_on_form_answer_id ON palace_invites USING btree (form_answer_id);


--
-- Name: index_press_summaries_on_form_answer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_press_summaries_on_form_answer_id ON press_summaries USING btree (form_answer_id);


--
-- Name: index_scans_on_uuid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_scans_on_uuid ON scans USING btree (uuid);


--
-- Name: index_settings_on_award_year_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_settings_on_award_year_id ON settings USING btree (award_year_id);


--
-- Name: index_support_letter_attachments_on_form_answer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_support_letter_attachments_on_form_answer_id ON support_letter_attachments USING btree (form_answer_id);


--
-- Name: index_support_letter_attachments_on_support_letter_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_support_letter_attachments_on_support_letter_id ON support_letter_attachments USING btree (support_letter_id);


--
-- Name: index_support_letter_attachments_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_support_letter_attachments_on_user_id ON support_letter_attachments USING btree (user_id);


--
-- Name: index_support_letters_on_form_answer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_support_letters_on_form_answer_id ON support_letters USING btree (form_answer_id);


--
-- Name: index_support_letters_on_supporter_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_support_letters_on_supporter_id ON support_letters USING btree (supporter_id);


--
-- Name: index_support_letters_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_support_letters_on_user_id ON support_letters USING btree (user_id);


--
-- Name: index_supporters_on_access_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_supporters_on_access_key ON supporters USING btree (access_key);


--
-- Name: index_supporters_on_form_answer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_supporters_on_form_answer_id ON supporters USING btree (form_answer_id);


--
-- Name: index_supporters_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_supporters_on_user_id ON supporters USING btree (user_id);


--
-- Name: index_users_on_account_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_account_id ON users USING btree (account_id);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_users_on_unlock_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_unlock_token ON users USING btree (unlock_token);


--
-- Name: index_version_associations_on_foreign_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_version_associations_on_foreign_key ON version_associations USING btree (foreign_key_name, foreign_key_id);


--
-- Name: index_version_associations_on_version_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_version_associations_on_version_id ON version_associations USING btree (version_id);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_versions_on_item_type_and_item_id ON versions USING btree (item_type, item_id);


--
-- Name: index_versions_on_transaction_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_versions_on_transaction_id ON versions USING btree (transaction_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_0f5a0025a7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY support_letter_attachments
    ADD CONSTRAINT fk_rails_0f5a0025a7 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_20f2c914c7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY supporters
    ADD CONSTRAINT fk_rails_20f2c914c7 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_40aaf5af73; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY palace_invites
    ADD CONSTRAINT fk_rails_40aaf5af73 FOREIGN KEY (form_answer_id) REFERENCES form_answers(id);


--
-- Name: fk_rails_5e975fee43; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY support_letter_attachments
    ADD CONSTRAINT fk_rails_5e975fee43 FOREIGN KEY (support_letter_id) REFERENCES support_letters(id);


--
-- Name: fk_rails_6019307b8c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY palace_attendees
    ADD CONSTRAINT fk_rails_6019307b8c FOREIGN KEY (palace_invite_id) REFERENCES palace_invites(id);


--
-- Name: fk_rails_85a1d7f049; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY feedbacks
    ADD CONSTRAINT fk_rails_85a1d7f049 FOREIGN KEY (form_answer_id) REFERENCES form_answers(id);


--
-- Name: fk_rails_9087c6fe61; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY press_summaries
    ADD CONSTRAINT fk_rails_9087c6fe61 FOREIGN KEY (form_answer_id) REFERENCES form_answers(id);


--
-- Name: fk_rails_abd43a0510; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY support_letter_attachments
    ADD CONSTRAINT fk_rails_abd43a0510 FOREIGN KEY (form_answer_id) REFERENCES form_answers(id);


--
-- Name: fk_rails_fae9e85e5f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY support_letters
    ADD CONSTRAINT fk_rails_fae9e85e5f FOREIGN KEY (form_answer_id) REFERENCES form_answers(id);


--
-- Name: fk_rails_fe9ef772b4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY support_letters
    ADD CONSTRAINT fk_rails_fe9ef772b4 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20141124095215');

INSERT INTO schema_migrations (version) VALUES ('20141124112326');

INSERT INTO schema_migrations (version) VALUES ('20141124161532');

INSERT INTO schema_migrations (version) VALUES ('20141127094914');

INSERT INTO schema_migrations (version) VALUES ('20141127094940');

INSERT INTO schema_migrations (version) VALUES ('20141127095334');

INSERT INTO schema_migrations (version) VALUES ('20141128115405');

INSERT INTO schema_migrations (version) VALUES ('20141130191608');

INSERT INTO schema_migrations (version) VALUES ('20141201084521');

INSERT INTO schema_migrations (version) VALUES ('20141203090803');

INSERT INTO schema_migrations (version) VALUES ('20141203135504');

INSERT INTO schema_migrations (version) VALUES ('20141203140154');

INSERT INTO schema_migrations (version) VALUES ('20141203172220');

INSERT INTO schema_migrations (version) VALUES ('20141203182047');

INSERT INTO schema_migrations (version) VALUES ('20141204113405');

INSERT INTO schema_migrations (version) VALUES ('20141204113729');

INSERT INTO schema_migrations (version) VALUES ('20141204134014');

INSERT INTO schema_migrations (version) VALUES ('20141204161223');

INSERT INTO schema_migrations (version) VALUES ('20141208085751');

INSERT INTO schema_migrations (version) VALUES ('20141208105812');

INSERT INTO schema_migrations (version) VALUES ('20141209150903');

INSERT INTO schema_migrations (version) VALUES ('20141211103406');

INSERT INTO schema_migrations (version) VALUES ('20141211103425');

INSERT INTO schema_migrations (version) VALUES ('20141217112332');

INSERT INTO schema_migrations (version) VALUES ('20141219102035');

INSERT INTO schema_migrations (version) VALUES ('20150109142716');

INSERT INTO schema_migrations (version) VALUES ('20150112121539');

INSERT INTO schema_migrations (version) VALUES ('20150113154435');

INSERT INTO schema_migrations (version) VALUES ('20150113155731');

INSERT INTO schema_migrations (version) VALUES ('20150216232552');

INSERT INTO schema_migrations (version) VALUES ('20150217114106');

INSERT INTO schema_migrations (version) VALUES ('20150218132412');

INSERT INTO schema_migrations (version) VALUES ('20150218141547');

INSERT INTO schema_migrations (version) VALUES ('20150218150006');

INSERT INTO schema_migrations (version) VALUES ('20150219102528');

INSERT INTO schema_migrations (version) VALUES ('20150219125327');

INSERT INTO schema_migrations (version) VALUES ('20150223100419');

INSERT INTO schema_migrations (version) VALUES ('20150223115842');

INSERT INTO schema_migrations (version) VALUES ('20150223123005');

INSERT INTO schema_migrations (version) VALUES ('20150224115303');

INSERT INTO schema_migrations (version) VALUES ('20150224115503');

INSERT INTO schema_migrations (version) VALUES ('20150225090728');

INSERT INTO schema_migrations (version) VALUES ('20150225122104');

INSERT INTO schema_migrations (version) VALUES ('20150226141107');

INSERT INTO schema_migrations (version) VALUES ('20150227124243');

INSERT INTO schema_migrations (version) VALUES ('20150227125140');

INSERT INTO schema_migrations (version) VALUES ('20150227125226');

INSERT INTO schema_migrations (version) VALUES ('20150227125421');

INSERT INTO schema_migrations (version) VALUES ('20150227135432');

INSERT INTO schema_migrations (version) VALUES ('20150227141437');

INSERT INTO schema_migrations (version) VALUES ('20150228145247');

INSERT INTO schema_migrations (version) VALUES ('20150302092030');

INSERT INTO schema_migrations (version) VALUES ('20150302095528');

INSERT INTO schema_migrations (version) VALUES ('20150303120704');

INSERT INTO schema_migrations (version) VALUES ('20150303123415');

INSERT INTO schema_migrations (version) VALUES ('20150303152052');

INSERT INTO schema_migrations (version) VALUES ('20150303163541');

INSERT INTO schema_migrations (version) VALUES ('20150304075824');

INSERT INTO schema_migrations (version) VALUES ('20150304080108');

INSERT INTO schema_migrations (version) VALUES ('20150304084018');

INSERT INTO schema_migrations (version) VALUES ('20150304144532');

INSERT INTO schema_migrations (version) VALUES ('20150304145423');

INSERT INTO schema_migrations (version) VALUES ('20150304155948');

INSERT INTO schema_migrations (version) VALUES ('20150305084628');

INSERT INTO schema_migrations (version) VALUES ('20150305104844');

INSERT INTO schema_migrations (version) VALUES ('20150306122216');

INSERT INTO schema_migrations (version) VALUES ('20150309112759');

INSERT INTO schema_migrations (version) VALUES ('20150309114102');

INSERT INTO schema_migrations (version) VALUES ('20150309114427');

INSERT INTO schema_migrations (version) VALUES ('20150309143448');

INSERT INTO schema_migrations (version) VALUES ('20150310114756');

INSERT INTO schema_migrations (version) VALUES ('20150310124624');

INSERT INTO schema_migrations (version) VALUES ('20150310130907');

INSERT INTO schema_migrations (version) VALUES ('20150312105021');

INSERT INTO schema_migrations (version) VALUES ('20150312114528');

INSERT INTO schema_migrations (version) VALUES ('20150313090152');

INSERT INTO schema_migrations (version) VALUES ('20150317130146');

INSERT INTO schema_migrations (version) VALUES ('20150318123932');

INSERT INTO schema_migrations (version) VALUES ('20150318142055');

INSERT INTO schema_migrations (version) VALUES ('20150323132637');

INSERT INTO schema_migrations (version) VALUES ('20150323155826');

INSERT INTO schema_migrations (version) VALUES ('20150324104816');

INSERT INTO schema_migrations (version) VALUES ('20150324104913');

INSERT INTO schema_migrations (version) VALUES ('20150324163344');

INSERT INTO schema_migrations (version) VALUES ('20150325092930');

INSERT INTO schema_migrations (version) VALUES ('20150325133040');

INSERT INTO schema_migrations (version) VALUES ('20150325160755');

INSERT INTO schema_migrations (version) VALUES ('20150325201007');

INSERT INTO schema_migrations (version) VALUES ('20150326105117');

INSERT INTO schema_migrations (version) VALUES ('20150326170750');

INSERT INTO schema_migrations (version) VALUES ('20150326170823');

INSERT INTO schema_migrations (version) VALUES ('20150326221536');

INSERT INTO schema_migrations (version) VALUES ('20150327122904');

INSERT INTO schema_migrations (version) VALUES ('20150327190410');

INSERT INTO schema_migrations (version) VALUES ('20150331061542');

INSERT INTO schema_migrations (version) VALUES ('20150331180118');

INSERT INTO schema_migrations (version) VALUES ('20150406130916');

INSERT INTO schema_migrations (version) VALUES ('20150407122134');

INSERT INTO schema_migrations (version) VALUES ('20150407132835');

INSERT INTO schema_migrations (version) VALUES ('20150407134028');

INSERT INTO schema_migrations (version) VALUES ('20150407172016');

INSERT INTO schema_migrations (version) VALUES ('20150409082247');

INSERT INTO schema_migrations (version) VALUES ('20150409090140');

INSERT INTO schema_migrations (version) VALUES ('20150410091747');

INSERT INTO schema_migrations (version) VALUES ('20150410131705');

INSERT INTO schema_migrations (version) VALUES ('20150411113516');

INSERT INTO schema_migrations (version) VALUES ('20150411113532');

INSERT INTO schema_migrations (version) VALUES ('20150411113543');

INSERT INTO schema_migrations (version) VALUES ('20150411113558');

INSERT INTO schema_migrations (version) VALUES ('20150414102640');

INSERT INTO schema_migrations (version) VALUES ('20150414133524');

INSERT INTO schema_migrations (version) VALUES ('20150414141823');

INSERT INTO schema_migrations (version) VALUES ('20150414170238');

INSERT INTO schema_migrations (version) VALUES ('20150417153811');

INSERT INTO schema_migrations (version) VALUES ('20150427100604');

INSERT INTO schema_migrations (version) VALUES ('20150429171132');

INSERT INTO schema_migrations (version) VALUES ('20150429171704');

INSERT INTO schema_migrations (version) VALUES ('20150429171705');

INSERT INTO schema_migrations (version) VALUES ('20150504112318');

INSERT INTO schema_migrations (version) VALUES ('20150506150526');

INSERT INTO schema_migrations (version) VALUES ('20150507114157');

INSERT INTO schema_migrations (version) VALUES ('20150507143136');

INSERT INTO schema_migrations (version) VALUES ('20150515145647');

INSERT INTO schema_migrations (version) VALUES ('20150519123524');

INSERT INTO schema_migrations (version) VALUES ('20150617142142');

INSERT INTO schema_migrations (version) VALUES ('20150622173914');

INSERT INTO schema_migrations (version) VALUES ('20150907131321');

INSERT INTO schema_migrations (version) VALUES ('20150907145343');

INSERT INTO schema_migrations (version) VALUES ('20150907145955');

INSERT INTO schema_migrations (version) VALUES ('20150907161006');

INSERT INTO schema_migrations (version) VALUES ('20150907165227');

INSERT INTO schema_migrations (version) VALUES ('20150908105756');

INSERT INTO schema_migrations (version) VALUES ('20150908151417');

INSERT INTO schema_migrations (version) VALUES ('20150908163040');

INSERT INTO schema_migrations (version) VALUES ('20150908172247');

INSERT INTO schema_migrations (version) VALUES ('20150914114817');

INSERT INTO schema_migrations (version) VALUES ('20150917134236');

INSERT INTO schema_migrations (version) VALUES ('20150917135114');

INSERT INTO schema_migrations (version) VALUES ('20150922132151');

INSERT INTO schema_migrations (version) VALUES ('20151001144155');

INSERT INTO schema_migrations (version) VALUES ('20151005112348');

INSERT INTO schema_migrations (version) VALUES ('20151126154434');

INSERT INTO schema_migrations (version) VALUES ('20151126171347');

INSERT INTO schema_migrations (version) VALUES ('20151130145800');

INSERT INTO schema_migrations (version) VALUES ('20160106115349');

INSERT INTO schema_migrations (version) VALUES ('20160121080201');

INSERT INTO schema_migrations (version) VALUES ('20160204203037');

INSERT INTO schema_migrations (version) VALUES ('20160222153821');

INSERT INTO schema_migrations (version) VALUES ('20160222175452');

INSERT INTO schema_migrations (version) VALUES ('20160224174712');

