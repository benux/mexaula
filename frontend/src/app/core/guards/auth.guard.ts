import { inject } from '@angular/core';
import { Router, CanActivateFn } from '@angular/router';
import { AuthService } from '../services/auth.service';
import { map, filter, take } from 'rxjs/operators';

export const authGuard: CanActivateFn = (route, state) => {
  const authService = inject(AuthService);
  const router = inject(Router);

  // Esperar a que el usuario se cargue
  return authService.userLoaded$.pipe(
    filter(loaded => loaded), // Solo continuar cuando esté cargado
    take(1), // Tomar solo el primer valor después de cargar
    map(() => {
      if (authService.isAuthenticated() && authService.getCurrentUser()) {
        return true;
      }

      router.navigate(['/auth/login'], { queryParams: { returnUrl: state.url } });
      return false;
    })
  );
};

