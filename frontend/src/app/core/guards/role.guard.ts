import { inject } from '@angular/core';
import { Router, CanActivateFn } from '@angular/router';
import { AuthService } from '../services/auth.service';
import { map, filter, take } from 'rxjs/operators';

export const roleGuard: CanActivateFn = (route) => {
  const authService = inject(AuthService);
  const router = inject(Router);

  const requiredRoles = route.data['roles'] as string[] | undefined;

  if (!requiredRoles || requiredRoles.length === 0) {
    return true;
  }

  // Esperar a que el usuario se cargue
  return authService.userLoaded$.pipe(
    filter(loaded => loaded),
    take(1),
    map(() => {
      if (authService.hasAnyRole(requiredRoles)) {
        return true;
      }

      router.navigate(['/dashboard']);
      return false;
    })
  );
};

