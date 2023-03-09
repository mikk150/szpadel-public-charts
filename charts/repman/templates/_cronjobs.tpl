
{{/* Make sure all variables are set properly */}}
{{- include "common.values.setup" . }}

{{- define "repman.cronjob" -}}
enabled: true
type: cronjob
schedule: {{ .schedule }}
failedJobsHistoryLimit: 1
successfulJobsHistoryLimit: 1
restartPolicy: Never
command:
- sh
- -c
- |
  set -euo pipefail
  /app/bin/console {{ .command | quote }}
persistence:
  public:
    enabled: false
{{- end -}}
