{{- define "cmak.name" -}}
cmak
{{- end -}}

{{- define "cmak.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cmak.name" . | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
{{- end -}}

{{- define "cmak.labels" -}}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | quote }}
{{ include "cmak.selectorLabels" . }}
{{- end -}}


