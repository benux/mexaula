import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Enrollment, UpdateProgressRequest } from '../models/enrollment.model';
import { environment } from '../../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class EnrollmentService {
  private readonly API_URL = `${environment.apiUrl}/enrollments`;

  constructor(private http: HttpClient) {}

  // Obtener todas las inscripciones del usuario actual
  getMyEnrollments(): Observable<Enrollment[]> {
    return this.http.get<Enrollment[]>(`${this.API_URL}/my`);
  }

  // Verificar si el usuario está inscrito en un curso específico
  isEnrolledInCourse(courseId: number): Observable<boolean> {
    return this.http.get<boolean>(`${this.API_URL}/check/${courseId}`);
  }

  updateProgress(enrollmentId: number, progreso: number, completado?: boolean): Observable<Enrollment> {
    const payload: UpdateProgressRequest = {
      progresoPorcentaje: progreso,
      completado
    };
    return this.http.put<Enrollment>(`${this.API_URL}/${enrollmentId}/progress`, payload);
  }
}

