# CampusConnect email notifications

The backend sends welcome emails after student registration, sign-in notices after login, event registration confirmations, and event reminders. It uses SMTP; no email provider account or credentials are included in the repository.

Configure these environment variables for the backend process:

| Variable | Purpose |
| --- | --- |
| `MAIL_HOST` | SMTP server, such as `smtp.gmail.com` |
| `MAIL_PORT` | SMTP port, usually `587` for STARTTLS |
| `MAIL_USERNAME` | SMTP account username |
| `MAIL_PASSWORD` | SMTP password or provider app password |
| `MAIL_SMTP_AUTH` | Set to `true` when the provider requires login |
| `MAIL_SMTP_STARTTLS` | Set to `true` when using STARTTLS |

For Gmail, use an app password from the Google account that will send CampusConnect messages. Do not use or commit the account's normal password. Set the variables in the environment that launches Spring Boot, then restart the backend. For example, in PowerShell:

```powershell
$env:MAIL_HOST = 'smtp.gmail.com'
$env:MAIL_PORT = '587'
$env:MAIL_USERNAME = 'campusconnect.sender@gmail.com'
$env:MAIL_PASSWORD = 'provider-app-password'
$env:MAIL_SMTP_AUTH = 'true'
$env:MAIL_SMTP_STARTTLS = 'true'
```

Student registration is open from the login page. Teacher and admin accounts must already exist in the users table and have the `TEACHER`/`NOTICE_MANAGER` or `ADMIN` role; the public registration endpoint intentionally cannot create privileged accounts.

The reminder worker checks hourly by default. It sends reminders every three days while the event is more than three days away, then at about one day and three hours before the event. If SMTP delivery fails, it retries in an hour. A registration must have a real future event date for reminders to work. The current sample events use placeholder dates in the Flutter mock data; replace those dates when loading real event records.
