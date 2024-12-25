{{/*
Adding common labels
*/}}
{{- define "app.labels" -}}
helm.sh/chart: {{ .Release.Name }}
app.kubernetes.io/name: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}