{{/* Make sure all variables are set properly */}}
{{- include "common.values.setup" . }}


{{- define "seafile.values.setup" -}}
{{- if .Values.seafile.pro -}}
    {{/* This is non pro image, replace it with pro */}}
    {{- if eq .Values.image.repository "seafileltd/seafile-mc" -}}
        {{- $_ := set .Values.image "repository" "docker.seadrive.org/seafileltd/seafile-pro-mc" -}}
    {{- end -}}
{{- end -}}
{{- end -}}
