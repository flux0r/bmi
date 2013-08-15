create table if not exists bmi_post (
	id bigserial primary key,
	author_id bigint not null references bmi_author(id),
	created timestamp with time zone not null,
	content text not null,
	title text not null,
	excerpt text not null,
	status_id bigint not null references bmi_status_post(id),
	path text not null,
	revision_id bigint not null references bmi_revision_post(id)
)

create table if not exists bmi_author (
	id bigserial primary key,
	login character varying(64) not null,
	pass character varying(256) not null,
	nicename character varying(64) not null,
	email character varying(254) not null,
	displayname character varying(256) not null,
	registered timestamp with time zone not null,
	status_id bigint not null references bmi_status_author(id)
)
