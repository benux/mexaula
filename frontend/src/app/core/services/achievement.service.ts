import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Achievement, UserAchievement } from '../models/achievement.model';
import { environment } from '../../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class AchievementService {
  private readonly API_URL = `${environment.apiUrl}/achievements`;

  constructor(private readonly http: HttpClient) {}

  // GET / - Lista todos los logros (ADMIN)
  getAll(): Observable<Achievement[]> {
    return this.http.get<Achievement[]>(this.API_URL);
  }

  // GET /my - Logros del alumno autenticado
  getMyAchievements(): Observable<UserAchievement[]> {
    return this.http.get<UserAchievement[]>(`${this.API_URL}/my`);
  }

  // POST / - Crear logro (ADMIN)
  create(achievement: Partial<Achievement>): Observable<Achievement> {
    return this.http.post<Achievement>(this.API_URL, achievement);
  }

  // PUT /{id} - Actualizar logro (ADMIN)
  update(id: number, achievement: Partial<Achievement>): Observable<Achievement> {
    return this.http.put<Achievement>(`${this.API_URL}/${id}`, achievement);
  }

  // DELETE /{id} - Eliminar logro (ADMIN)
  delete(id: number): Observable<void> {
    return this.http.delete<void>(`${this.API_URL}/${id}`);
  }

  // POST /{userAchievementId}/shared - Incrementar compartidos
  incrementShared(userAchievementId: number): Observable<void> {
    return this.http.post<void>(`${this.API_URL}/${userAchievementId}/shared`, {});
  }

  // GET /{id} - Obtener un logro por ID (útil para edición)
  getById(id: number): Observable<Achievement> {
    return this.http.get<Achievement>(`${this.API_URL}/${id}`);
  }
}

