import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Course, CreateCourseRequest, UpdateCourseRequest } from '../models/course.model';
import { environment } from '../../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class CourseService {
  private readonly API_URL = `${environment.apiUrl}/courses`;

  constructor(private http: HttpClient) {}

  getAll(): Observable<Course[]> {
    return this.http.get<Course[]>(this.API_URL);
  }

  getById(id: number): Observable<Course> {
    return this.http.get<Course>(`${this.API_URL}/${id}`);
  }

  getMyCourses(): Observable<Course[]> {
    return this.http.get<Course[]>(`${this.API_URL}/my`);
  }

  getMyTeacherCourses(): Observable<Course[]> {
    return this.http.get<Course[]>(`${environment.apiUrl}/teachers/me/courses`);
  }

  enroll(courseId: number): Observable<void> {
    return this.http.post<void>(`${this.API_URL}/${courseId}/enroll`, {});
  }

  create(payload: CreateCourseRequest): Observable<Course> {
    return this.http.post<Course>(this.API_URL, payload);
  }

  update(id: number, payload: UpdateCourseRequest): Observable<Course> {
    return this.http.put<Course>(`${this.API_URL}/${id}`, payload);
  }

  delete(id: number): Observable<void> {
    return this.http.delete<void>(`${this.API_URL}/${id}`);
  }
}

