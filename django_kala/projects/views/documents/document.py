from django.contrib.auth.mixins import LoginRequiredMixin
from django.core.exceptions import PermissionDenied
from django.shortcuts import get_object_or_404, redirect
from django.urls import reverse
from django.views import View
from django.views.generic import TemplateView
from documents.models import Document
from projects.models import Project
from projects.tasks.export_document import ExportDocumentTask


class DocumentView(LoginRequiredMixin, TemplateView):
    template_name = 'documents/document.html'

    def get_context_data(self, **kwargs):
        return {
            'project': self.project,
            'document': self.document,
            'can_change': self.document.has_change(self.request.user),
            'can_create': self.has_change or self.has_create,
            'can_invite': self.project.organization.has_change(self.request.user) or self.project.organization.has_create(self.request.user)
        }

    def dispatch(self, request, project_pk, document_pk, *args, **kwargs):
        self.project = get_object_or_404(Project.objects.active(), pk=project_pk)
        self.document = get_object_or_404(
            Document.objects.active().prefetch_related(
                'documentversion_set',
                'documentversion_set__user'
            ),
            pk=document_pk)
        self.has_create = self.document.has_create(request.user)
        self.has_change = self.document.has_change(request.user)
        if not self.has_create and not self.has_change and not self.document.has_delete(request.user):
            raise PermissionDenied('You do not have permissions to view this document.')
        return super(DocumentView, self).dispatch(request, *args, **kwargs)


class ExportDocumentView(LoginRequiredMixin, View):

    def dispatch(self, request, project_pk, document_pk, *args, **kwargs):
        self.project = get_object_or_404(Project.objects.active(), pk=project_pk)
        self.document = get_object_or_404(
            Document.objects.active(),
            pk=document_pk)

        has_create = self.document.has_create(request.user)
        has_change = self.document.has_change(request.user)
        has_delete = self.document.has_delete(request.user)
        if not has_create and not has_change and not has_delete:
            raise PermissionDenied('You do not have permissions to view this document.')
        return super(ExportDocumentView, self).dispatch(request, *args, **kwargs)

    def get(self, request, *args, **kwargs):
        task = ExportDocumentTask()
        task.apply_async([self.document.pk, request.user.pk])

        return redirect(
            reverse(
                'projects:document',
                args=[self.project.pk, self.document.pk]
            )
        )
