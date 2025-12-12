import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { TechPost } from '../models/tech-post.model';
import { environment } from '../../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class TechPostService {
  private readonly API_URL = `${environment.apiUrl}/tech-posts`;

  constructor(private readonly http: HttpClient) {}

  // GET / - Posts publicados (público)
  getPublished(): Observable<TechPost[]> {
    return this.http.get<TechPost[]>(this.API_URL);
  }

  // GET /slug/{slug} - Obtener post por slug
  getBySlug(slug: string): Observable<TechPost> {
    return this.http.get<TechPost>(`${this.API_URL}/slug/${slug}`);
  }

  // GET /admin - Todos los posts (ADMIN/MAESTRO)
  getAllForAdmin(): Observable<TechPost[]> {
    return this.http.get<TechPost[]>(`${this.API_URL}/admin`);
  }

  // POST / - Crear post (ADMIN/MAESTRO)
  create(post: Partial<TechPost>): Observable<TechPost> {
    return this.http.post<TechPost>(this.API_URL, post);
  }

  // PUT /{id} - Actualizar post (ADMIN/MAESTRO)
  update(id: number, post: Partial<TechPost>): Observable<TechPost> {
    return this.http.put<TechPost>(`${this.API_URL}/${id}`, post);
  }

  // DELETE /{id} - Eliminar post (ADMIN/MAESTRO)
  delete(id: number): Observable<void> {
    return this.http.delete<void>(`${this.API_URL}/${id}`);
  }

  // GET /{id} - Obtener post por ID (útil para edición)
  getById(id: number): Observable<TechPost> {
    return this.http.get<TechPost>(`${this.API_URL}/${id}`);
  }
}

