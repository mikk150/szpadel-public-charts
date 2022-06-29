{{/*
Expand the name of the chart.
*/}}
{{- define "repman.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "repman.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "repman.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "repman.labels" -}}
helm.sh/chart: {{ include "repman.chart" . }}
{{ include "repman.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "repman.selectorLabels" -}}
app.kubernetes.io/name: {{ include "repman.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{/*
WWW labels
*/}}
{{- define "repman.www.labels" -}}
helm.sh/chart: {{ include "repman.chart" . }}
{{ include "repman.www.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
WWW Selector labels
*/}}
{{- define "repman.www.selectorLabels" -}}
app.kubernetes.io/name: {{ include "repman.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
role: www
{{- end }}

{{/*
consumer labels
*/}}
{{- define "repman.consumer.labels" -}}
helm.sh/chart: {{ include "repman.chart" . }}
{{ include "repman.consumer.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
consumer Selector labels
*/}}
{{- define "repman.consumer.selectorLabels" -}}
app.kubernetes.io/name: {{ include "repman.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
role: consumer
{{- end }}


{{/*
posgresql database credentials*/}}
{{- define "repman.database.credentials.env" -}}
{{- if and .Values.bitnamiDatabase.enabled .Values.perconaOperator.enabled .Values.externalDatabase.enabled -}}
{{ required "Exactly one of perconaOperator or bitnamiDatabase need to be enabled" "" }}
{{- end -}}

{{- if .Values.bitnamiDatabase.enabled }}
- name: DATABASE_HOSTNAME
  value: {{ include "repman.fullname" . }}-postgresql
- name: DATABASE_USER
  valueFrom:
    secretKeyRef:
      key: USER
      name: {{ include "repman.fullname" . }}-database
- name: DATABASE_PASSWORD
  valueFrom:
    secretKeyRef:
      key: PASSWORD
      name: {{ include "repman.fullname" . }}-database
- name: DATABASE_DATABASE
  value: {{ .Values.postgresql.auth.database }}
{{- else if .Values.perconaOperator.enabled -}}
- name: DATABASE_HOSTNAME
  value: {{ include "repman.fullname" . }}-database-pgbouncer
- name: DATABASE_USER
  value: {{ .Values.postgresql.auth.username }}
- name: DATABASE_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "repman.fullname" . }}-database-users
      key: {{ .Values.postgresql.auth.username }}
- name: DATABASE_DATABASE
  value: {{ .Values.postgresql.auth.database }}
{{- else if .Values.externalDatabase.enabled -}}
- name: DATABASE_HOSTNAME
  value: {{ .Values.externalDatabase.hostname }}
- name: DATABASE_USER
  value: {{ .Values.externalDatabase.user }}
- name: DATABASE_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.externalDatabase.passwordSecret.name }}
      key: {{ .Values.externalDatabase.passwordSecret.key }}
- name: DATABASE_DATABASE
  value: {{ .Values.externalDatabase.database }}
{{- else -}}
{{ required "Exactly one of perconaOperator or bitnamiDatabase need to be enabled" }}
{{- end -}}
{{- end }}
