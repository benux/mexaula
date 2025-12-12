import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { CourseService } from '../../core/services/course.service';
import { Course } from '../../core/models/course.model';
import { NotificationService } from '../../core/services/notification.service';

@Component({
  selector: 'app-course-admin-list',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './course-admin-list.component.html'
})
export class CourseAdminListComponent implements OnInit {
  courses: Course[] = [];
  isLoading = false;

  constructor(
    private courseService: CourseService,
    private notificationService: NotificationService
  ) {}

  ngOnInit(): void {
    this.loadCourses();
  }

  loadCourses(): void {
    this.isLoading = true;
    this.courseService.getAll().subscribe({
      next: (courses) => {
        this.courses = courses;
        this.isLoading = false;
      },
      error: () => {
        this.isLoading = false;
      }
    });
  }

  deleteCourse(id: number): void {
    if (confirm('¿Estás seguro de eliminar este curso?')) {
      this.courseService.delete(id).subscribe({
        next: () => {
          this.notificationService.success('Curso eliminado exitosamente');
          this.loadCourses();
        },
        error: () => {
          this.notificationService.error('Error al eliminar el curso');
        }
      });
    }
  }
}
