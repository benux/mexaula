import { HttpInterceptorFn, HttpErrorResponse } from '@angular/common/http';
import { inject } from '@angular/core';
import { Router } from '@angular/router';
import { catchError, throwError } from 'rxjs';
import { NotificationService } from '../services/notification.service';
import { AuthService } from '../services/auth.service';

export const errorInterceptor: HttpInterceptorFn = (req, next) => {
  const router = inject(Router);
  const notificationService = inject(NotificationService);
  const authService = inject(AuthService);

  return next(req).pipe(
    catchError((error: HttpErrorResponse) => {
      if (error.status === 401) {
        // Limpiar la sesión cuando el token es inválido o expirado
        authService.logout();
        notificationService.error('Sesión expirada. Por favor, inicia sesión nuevamente.');
        router.navigate(['/auth/login']);
      } else if (error.status === 403) {
        notificationService.error('No tienes permisos para realizar esta acción.');
      } else if (error.status === 404) {
        notificationService.error('Recurso no encontrado.');
      } else if (error.status === 500) {
        notificationService.error('Error del servidor. Intenta nuevamente más tarde.');
      } else if (error.error?.message) {
        notificationService.error(error.error.message);
      }

      return throwError(() => error);
    })
  );
};

