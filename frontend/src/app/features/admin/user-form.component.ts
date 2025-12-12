import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, Validators, ReactiveFormsModule } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { UserService } from '../../core/services/user.service';
import { NotificationService } from '../../core/services/notification.service';
import { Role } from '../../core/models/user.model';

@Component({
  selector: 'app-user-form',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './user-form.component.html'
})
export class UserFormComponent implements OnInit {
  userForm: FormGroup;
  isEditMode = false;
  isLoading = false;
  userId: number | null = null;
  availableRoles: Role[] = ['ADMIN', 'PADRE', 'MAESTRO', 'ALUMNO'];
  selectedRoles: Role[] = [];

  constructor(
    private fb: FormBuilder,
    private route: ActivatedRoute,
    private router: Router,
    private userService: UserService,
    private notificationService: NotificationService
  ) {
    this.userForm = this.fb.group({
      nombre: ['', Validators.required],
      apellido: ['', Validators.required],
      email: ['', [Validators.required, Validators.email]],
      password: [''],
      activo: [true]
    });
  }

  ngOnInit(): void {
    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      this.isEditMode = true;
      this.userId = +id;
      this.loadUser(this.userId);
    } else {
      this.userForm.get('password')?.setValidators([Validators.required, Validators.minLength(6)]);
    }
  }

  loadUser(id: number): void {
    this.userService.getById(id).subscribe({
      next: (user) => {
        this.userForm.patchValue(user);
        this.selectedRoles = user.roles;
      }
    });
  }

  onRoleChange(event: any): void {
    const role = event.target.value as Role;
    if (event.target.checked) {
      this.selectedRoles.push(role);
    } else {
      const index = this.selectedRoles.indexOf(role);
      if (index > -1) this.selectedRoles.splice(index, 1);
    }
  }

  onSubmit(): void {
    if (this.userForm.valid) {
      this.isLoading = true;
      const payload = { ...this.userForm.value, roles: this.selectedRoles };

      const request = this.isEditMode && this.userId
        ? this.userService.update(this.userId, payload)
        : this.userService.create(payload);

      request.subscribe({
        next: () => {
          this.notificationService.success(this.isEditMode ? 'Usuario actualizado' : 'Usuario creado');
          this.goBack();
        },
        error: () => { this.isLoading = false; }
      });
    }
  }

  goBack(): void {
    this.router.navigate(['/admin/users']);
  }
}
