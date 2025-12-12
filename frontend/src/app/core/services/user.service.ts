import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { User, ChangePasswordRequest, Role } from '../models/user.model';
import { environment } from '../../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class UserService {
  private readonly API_URL = `${environment.apiUrl}/users`;

  constructor(private http: HttpClient) {}

  getMe(): Observable<User> {
    return this.http.get<User>(`${this.API_URL}/me`);
  }

  updateMe(payload: Partial<User>): Observable<User> {
    return this.http.put<User>(`${this.API_URL}/me`, payload);
  }

  changePassword(payload: ChangePasswordRequest): Observable<void> {
    return this.http.post<void>(`${this.API_URL}/change-password`, payload);
  }

  // Admin only endpoints
  getAll(): Observable<User[]> {
    return this.http.get<User[]>(this.API_URL);
  }

  getById(id: number): Observable<User> {
    return this.http.get<User>(`${this.API_URL}/${id}`);
  }

  create(payload: Partial<User> & { password: string }): Observable<User> {
    return this.http.post<User>(this.API_URL, payload);
  }

  update(id: number, payload: Partial<User>): Observable<User> {
    return this.http.put<User>(`${this.API_URL}/${id}`, payload);
  }

  toggleStatus(id: number, activo: boolean): Observable<User> {
    return this.http.patch<User>(`${this.API_URL}/${id}/status`, { activo });
  }

  getRoles(): Observable<Role[]> {
    return this.http.get<Role[]>(`${this.API_URL}/roles`);
  }
}

