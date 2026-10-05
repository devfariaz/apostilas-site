-- O conteúdo do guia do professor é cadastrado como texto no banco.
-- O PDF de referência é opcional e pode ficar vazio.
alter table public.teacher_guides
  alter column source_filename drop not null,
  alter column storage_path drop not null,
  alter column page_count set default 1;
