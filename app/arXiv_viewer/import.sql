create table papers (
	id integer primary key,
	title text,
	abstract text,
	published text,
	link_pdf text,
	created_at,
	updated_at
);

create table authors (
	id integer primary key,
	name text
);

create table author_paper_relations (
	id integer primary key,
	author_id integer,
	paper_id integer
);
