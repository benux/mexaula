import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, Validators, ReactiveFormsModule } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { CourseService } from '../../core/services/course.service';
import { UserService } from '../../core/services/user.service';
import { NotificationService } from '../../core/services/notification.service';
import { User } from '../../core/models/user.model';

@Component({
  selector: 'app-course-form',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './course-form.component.html'
})
export class CourseFormComponent implements OnInit {
  courseForm: FormGroup;
  isEditMode = false;
  isLoading = false;
  courseId: number | null = null;
  teachers: User[] = [];

  constructor(
    private fb: FormBuilder,
    private route: ActivatedRoute,
    private router: Router,
    private courseService: CourseService,
    private userService: UserService,
    private notificationService: NotificationService
  ) {
    this.courseForm = this.fb.group({
      titulo: ['', Validators.required],
      descripcion: ['', Validators.required],
      nivel: ['BASICO', Validators.required],
      maestroId: [''],
      publicado: [false]
    });
  }

  ngOnInit(): void {
    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      this.isEditMode = true;
      this.courseId = +id;
      this.loadCourse(this.courseId);
    } else {
      this.loadTeachers();
    }
  }

  loadCourse(id: number): void {
    this.courseService.getById(id).subscribe({
      next: (course) => {
        this.courseForm.patchValue({
          titulo: course.titulo,
          descripcion: course.descripcion,
          nivel: course.nivel,
          publicado: course.publicado
        });
      }
    });
  }

  loadTeachers(): void {
    this.userService.getAll().subscribe({
      next: (users) => {
        this.teachers = users.filter(u => u.roles.includes('MAESTRO'));
      }
    });
  }

  onSubmit(): void {
    if (this.courseForm.valid) {
      this.isLoading = true;
      const payload = this.courseForm.value;

      const request = this.isEditMode && this.courseId
        ? this.courseService.update(this.courseId, payload)
        : this.courseService.create(payload);

      request.subscribe({
        next: () => {
          this.notificationService.success(
            this.isEditMode ? 'Curso actualizado' : 'Curso creado'
          );
          this.goBack();
        },
        error: () => {
          this.isLoading = false;
        }
      });
    }
  }

  goBack(): void {
    this.router.navigate(['/admin/courses']);
  }
}
