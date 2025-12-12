import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router, RouterModule } from '@angular/router';
import { CourseService } from '../../core/services/course.service';
import { Course } from '../../core/models/course.model';
import { NotificationService } from '../../core/services/notification.service';

/**
 * Componente para mostrar el detalle de un curso desde la vista "Mis Cursos" del maestro.
 * En este contexto, el maestro ve el curso que creó, con opciones de gestión.
 * El botón "Volver" regresa a la lista de cursos del maestro.
 */
@Component({
  selector: 'app-maestro-curso-detalle',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './maestro-curso-detalle.component.html'
})
export class MaestroCursoDetalleComponent implements OnInit {
  course: Course | null = null;
  isLoading = false;

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private courseService: CourseService,
    private notificationService: NotificationService
  ) {}

  ngOnInit(): void {
    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      this.loadCourse(+id);
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
        this.notificationService.error('Error al cargar el curso');
      }
    });
  }

  // Volver a la lista de cursos del maestro
  goBack(): void {
    this.router.navigate(['/maestro/courses']);
  }

  // Editar el curso
  editCourse(): void {
    if (this.course) {
      this.router.navigate(['/admin/courses', this.course.id, 'edit']);
    }
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

