from django.contrib import messages
from django.contrib.auth import get_user
from django.contrib.auth.decorators import login_required
from django.core.urlresolvers import reverse
from django.shortcuts import get_object_or_404, redirect
from django.utils.decorators import method_decorator
from django.views.generic import TemplateView
from .forms import PersonForm, CreatePersonForm, permission_forms, DeletedCompanyForm
from .mixins import LoginRequiredMixin
from .models import User
from companies.forms import CreateCompanyForm
from companies.models import Company
from projects.models import Project


class EditProfile(LoginRequiredMixin, TemplateView):
    template_name = 'profile.html'

    def get_context_data(self, **kwargs):
        context = {
            'form': self.form,
            'person': self.person,
        }
        if self.request.user.is_admin:
            context['permission_forms'] = self.permission_forms
        return context

    def dispatch(self, request, pk, *args, **kwargs):
        self.person = get_object_or_404(User, pk=pk)
        if self.person != request.user and not request.user.is_admin:
            messages.error(request, 'You do not have permission to edit this persons account')
            return redirect(reverse('home'))
        self.form = PersonForm(request.POST or None, instance=self.person)
        if request.user.is_admin:
            self.permission_forms = permission_forms(request, self.person)
        return super(EditProfile, self).dispatch(request, *args, **kwargs)

    def post(self, request, *args, **kwargs):
        if 'toggle-admin' in request.POST and request.user.is_admin:
            self.person.is_admin = not self.person.is_admin
            self.person.save()
            if self.person.is_admin:
                messages.success(request, 'This user has been granted administrator privileges')
            else:
                messages.success(request, 'This user has had it\'s administrator privileges revoked')
            return redirect(reverse('edit_profile', args=[self.person.pk]))

        if 'delete' in request.POST and request.user.is_admin:
            self.person.set_active(False)
            messages.success(request, 'The person has been removed')
            return redirect(reverse('accounts'))

        if 'save-permissions' in request.POST:
            for form in self.permission_forms:
                if form.is_valid():
                    form.save()
            messages.success(request, 'The permissions have been updated')
            return redirect(reverse('edit_profile', args=[self.person.pk]))

        if self.form.is_valid():
            self.form.save()
            messages.success(request, 'Profile data has been saved')
            return redirect(reverse('edit_profile', args=[self.person.pk]))
        return self.render_to_response(self.get_context_data())


class PeopleView(LoginRequiredMixin, TemplateView):
    template_name = 'users.html'

    def get_context_data(self, **kwargs):
        return {
            'users': self.request.user.get_users().prefetch_related('companies'),
            'companies': self.request.user.get_companies()
        }
