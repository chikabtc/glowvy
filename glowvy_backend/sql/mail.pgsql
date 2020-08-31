--name: QueryMailTemplate
SELECT
    mail_template.Id,
    mail_template.subject,
    mail_template.body
FROM
    mail_template
WHERE
    mail_template.Id = $1
    AND mail_template.deleted_at IS NULL
    
--name: QueryEmailSubject
INSERT INTO subject (email)
VALUES ($1)
RETURNING id

--name: QuerySMTP
SELECT
    mail_smtp.Id,
    mail_smtp.Address,
    mail_smtp.Host,
    mail_smtp.Password,
    mail_smtp.Port
FROM
    mail_smtp
WHERE
    mail_smtp.Id = $1
    AND mail_smtp.deleted_at IS NULL
