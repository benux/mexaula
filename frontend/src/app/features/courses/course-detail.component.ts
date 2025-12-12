import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router, RouterModule } from '@angular/router';
import { CourseService } from '../../core/services/course.service';
import { EnrollmentService } from '../../core/services/enrollment.service';
import { Course } from '../../core/models/course.model';
import { NotificationService } from '../../core/services/notification.service';

@Component({
  selector: 'app-course-detail',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './course-detail.component.html'
})
export class CourseDetailComponent implements OnInit {
  course: Course | null = null;
  isLoading = false;
  isEnrolled = false; // Agregar para verificar si está inscrito

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private courseService: CourseService,
    private enrollmentService: EnrollmentService,
    private notificationService: NotificationService
  ) {}

  ngOnInit(): void {
    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      this.loadCourse(+id);
      this.checkEnrollment(+id);
    }
  }

  loadCourse(id: number): void {
    this.isLoading = true;
    this.courseService.getById(id).subscribe({
      next: (course) => {
        this.course = course;
        this.isLoading = false;
      },
      error: () => {
        this.isLoading = false;
      }
    });
  }

  // Verificar si el usuario ya está inscrito en este curso
  checkEnrollment(courseId: number): void {
    this.enrollmentService.isEnrolledInCourse(courseId).subscribe({
      next: (enrolled) => {
        this.isEnrolled = enrolled;
      },
      error: () => {
        this.isEnrolled = false;
      }
    });
  }

  enroll(): void {
    if (this.course && !this.isEnrolled) {
      this.courseService.enroll(this.course.id).subscribe({
        next: () => {
          this.notificationService.success('¡Inscripción exitosa!');
          this.isEnrolled = true;
          this.router.navigate(['/alumno/courses']);
        },
        error: () => {
          this.notificationService.error('Error al inscribirse en el curso');
        }
      });
    }
  }

  goBack(): void {
    this.router.navigate(['/courses']);
  }

  getLevelLabel(nivel: string): string {
    const labels: Record<string, string> = {
      'BASICO': 'Básico',
      'INTERMEDIO': 'Intermedio',
      'AVANZADO': 'Avanzado'
    };
    return labels[nivel] || nivel;
  }

  getLevelClass(nivel: string): string {
    const classes: Record<string, string> = {
      'BASICO': 'bg-blue-100 text-blue-800',
      'INTERMEDIO': 'bg-yellow-100 text-yellow-800',
      'AVANZADO': 'bg-red-100 text-red-800'
    };
    return classes[nivel] || 'bg-gray-100 text-gray-800';
  }
}
