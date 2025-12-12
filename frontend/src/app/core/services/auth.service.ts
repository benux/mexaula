import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { BehaviorSubject, Observable, tap } from 'rxjs';
import { User, LoginResponse, RegisterRequest } from '../models/user.model';
import { environment } from '../../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private readonly API_URL = `${environment.apiUrl}/auth`;
  private readonly TOKEN_KEY = 'auth_token';
  private readonly USER_KEY = 'current_user';

  private readonly currentUserSubject = new BehaviorSubject<User | null>(null);
  public currentUser$ = this.currentUserSubject.asObservable();

  private readonly userLoadedSubject = new BehaviorSubject<boolean>(false);
  public userLoaded$ = this.userLoadedSubject.asObservable();

  constructor(private readonly http: HttpClient) {
    this.loadUserFromStorage();
  }

  private loadUserFromStorage(): void {
    const token = this.getToken();
    const cachedUser = this.getCachedUser();

    if (token) {
      if (cachedUser) {
        // Cargar usuario desde cache inmediatamente
        this.currentUserSubject.next(cachedUser);
        this.userLoadedSubject.next(true);

        // Actualizar usuario en background
        // Si falla, el errorInterceptor manejará el logout si es 401
        this.getMe().subscribe({
          next: (user) => {
            this.currentUserSubject.next(user);
            this.cacheUser(user);
          },
          error: () => {
            // No hacer logout aquí, el errorInterceptor lo manejará si es necesario
          }
        });
      } else {
        // No hay cache, cargar desde servidor
        this.getMe().subscribe({
          next: (user) => {
            this.currentUserSubject.next(user);
            this.cacheUser(user);
            this.userLoadedSubject.next(true);
          },
          error: () => {
            // Si no hay cache y falla, limpiar todo
            this.logout();
            this.userLoadedSubject.next(true);
          }
        });
      }
    } else {
      this.userLoadedSubject.next(true);
    }
  }

  private cacheUser(user: User): void {
    localStorage.setItem(this.USER_KEY, JSON.stringify(user));
  }

  private getCachedUser(): User | null {
    const cached = localStorage.getItem(this.USER_KEY);
    if (cached) {
      try {
        return JSON.parse(cached);
      } catch {
        return null;
      }
    }
    return null;
  }

  login(email: string, password: string): Observable<LoginResponse> {
    return this.http.post<LoginResponse>(`${this.API_URL}/login`, { email, password })
      .pipe(
        tap(response => {
          this.setToken(response.token);
          this.currentUserSubject.next(response.user);
          this.cacheUser(response.user);
          this.userLoadedSubject.next(true);
        })
      );
  }

  register(payload: RegisterRequest): Observable<User> {
    return this.http.post<User>(`${this.API_URL}/register`, payload);
  }

  getMe(): Observable<User> {
    return this.http.get<User>(`${this.API_URL}/me`);
  }

  logout(): void {
    localStorage.removeItem(this.TOKEN_KEY);
    localStorage.removeItem(this.USER_KEY);
    this.currentUserSubject.next(null);
    if (!this.userLoadedSubject.value) {
      this.userLoadedSubject.next(true);
    }
  }

  getToken(): string | null {
    return localStorage.getItem(this.TOKEN_KEY);
  }

  private setToken(token: string): void {
    localStorage.setItem(this.TOKEN_KEY, token);
  }

  isAuthenticated(): boolean {
    return !!this.getToken();
  }

  // Obtener el usuario actual desde el BehaviorSubject
  getCurrentUser(): User | null {
    return this.currentUserSubject.value;
  }

  // Obtener el rol principal del usuario
  getUserRole(): string | null {
    const user = this.currentUserSubject.value;
    return user && user.roles.length > 0 ? user.roles[0] : null;
  }

  hasRole(role: string): boolean {
    const user = this.currentUserSubject.value;
    return user ? user.roles.includes(role as any) : false;
  }

  hasAnyRole(roles: string[]): boolean {
    return roles.some(role => this.hasRole(role));
  }
}

