import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { CourseService } from '../../core/services/course.service';
import { EnrollmentService } from '../../core/services/enrollment.service';
import { Course } from '../../core/models/course.model';
import { NotificationService } from '../../core/services/notification.service';

@Component({
  selector: 'app-course-list',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './course-list.component.html',
  styles: [`
    .line-clamp-3 {
      display: -webkit-box;
      -webkit-line-clamp: 3;
      -webkit-box-orient: vertical;
      overflow: hidden;
    }
  `]
})
export class CourseListComponent implements OnInit {
  courses: Course[] = [];
  isLoading = false;
  enrolledCourseIds: Set<number> = new Set(); // Almacenar IDs de cursos inscritos

  constructor(
    private courseService: CourseService,
    private enrollmentService: EnrollmentService,
    private notificationService: NotificationService
  ) {}

  ngOnInit(): void {
    this.loadCourses();
    this.loadEnrollments();
  }

  loadCourses(): void {
    this.isLoading = true;
    this.courseService.getAll().subscribe({
      next: (courses) => {
        this.courses = courses.filter(c => c.publicado);
        this.isLoading = false;
      },
      error: () => {
        this.isLoading = false;
      }
    });
  }

  // Cargar las inscripciones del usuario para verificar en qué cursos está inscrito
  loadEnrollments(): void {
    this.enrollmentService.getMyEnrollments().subscribe({
      next: (enrollments) => {
        this.enrolledCourseIds = new Set(enrollments.map(e => e.cursoId));
      },
      error: () => {
        // Si falla, continuar sin inscripciones
      }
    });
  }

  // Verificar si el usuario está inscrito en un curso específico
  estaInscrito(course: Course): boolean {
    return this.enrolledCourseIds.has(course.id);
  }

  enroll(courseId: number): void {
    this.courseService.enroll(courseId).subscribe({
      next: () => {
        this.notificationService.success('¡Inscripción exitosa!');
        this.enrolledCourseIds.add(courseId);
      },
      error: () => {
        this.notificationService.error('Error al inscribirse en el curso');
      }
    });
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

