create table errors
(
    id         integer   default nextval('errors_id_seq_1'::regclass) not null
        constraint errors_pk
            primary key,
    source     text,
    message    text,
    site_id    integer,
    time       timestamp default now(),
    browser_id text,
    visit_id   text,
    backup     text
);

alter table errors
    owner to measurement;

create unique index errors_id_uindex
    on errors (id);

create table sites_2_paris
(
    id                           integer,
    rank                         integer,
    site                         text,
    subpages                     text,
    scheme                       text,
    subpages_count               integer,
    state_scheme                 integer,
    state_subpages               integer,
    site_state                   text,
    ready                        boolean,
    timeout                      integer,
    state_openwpm_native_eu      integer,
    state_openwpm_native_usa     integer,
    state_openwpm_customall_eu   integer,
    state_openwpm_omaticno_eu    integer,
    state_openwpm_omaticall_eu   integer,
    state_openwpm_dontcare_eu    integer,
    state_openwpm_ninja_eu       integer,
    state_openwpm_cookieblock_eu integer,
    state_openwpm_superagent_eu  integer,
    log_customall                text
);

alter table sites
    owner to measurement;

create unique index sites_id_uindex
    on sites (id);

create table visits
(
    id                integer default nextval('visits_id_seq_1'::regclass),
    site_id           integer,
    subpage_id        integer,
    url               text,
    start_time        timestamp,
    finish_time       timestamp,
    state             integer,
    browser_id        text,
    timeout           integer,
    push_request      integer,
    push_response     integer,
    push_cookie       integer,
    push_localstorage integer,
    visit_id          text
);

alter table visits
    owner to measurement;

create table tranco_list
(
    id                       integer default nextval('tranco_list_id_seq1'::regclass) not null,
    rank                     integer,
    site                     text,
    subpages                 text,
    scheme                   text,
    subpages_count           integer,
    state_scheme             integer,
    state_subpages           integer,
    site_state               text,
    ready                    boolean,
    state_chrome_desktop_ger integer default '-1'::integer,
    in_scope                 boolean
);

alter table tranco_list
    owner to measurement;

