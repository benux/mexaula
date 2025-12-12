import { Routes } from '@angular/router';
import { authGuard } from './core/guards/auth.guard';
import { roleGuard } from './core/guards/role.guard';

export const routes: Routes = [
  {
    path: '',
    redirectTo: '/dashboard',
    pathMatch: 'full'
  },
  {
    path: 'auth/login',
    loadComponent: () => import('./features/auth/login.component').then(m => m.LoginComponent)
  },
  {
    path: 'auth/register',
    loadComponent: () => import('./features/auth/register.component').then(m => m.RegisterComponent)
  },
  {
    path: 'dashboard',
    loadComponent: () => import('./features/dashboard/dashboard.component').then(m => m.DashboardComponent),
    canActivate: [authGuard]
  },
  {
    path: 'courses',
    loadComponent: () => import('./features/courses/course-list.component').then(m => m.CourseListComponent),
    canActivate: [authGuard, roleGuard],
    data: { roles: ['ALUMNO', 'MAESTRO', 'ADMIN'] }
  },
  {
    path: 'courses/:id',
    loadComponent: () => import('./features/courses/course-detail.component').then(m => m.CourseDetailComponent),
    canActivate: [authGuard]
  },
  {
    path: 'alumno/courses',
    loadComponent: () => import('./features/courses/my-courses.component').then(m => m.MyCoursesComponent),
    canActivate: [authGuard, roleGuard],
    data: { roles: ['ALUMNO'] }
  },
  // Nueva ruta: detalle de curso desde Mis Inscripciones (alumno)
  {
    path: 'alumno/mis-inscripciones/curso/:id',
    loadComponent: () => import('./features/courses/alumno-inscripcion-detalle.component').then(m => m.AlumnoInscripcionDetalleComponent),
    canActivate: [authGuard, roleGuard],
    data: { roles: ['ALUMNO'] }
  },
  {
    path: 'maestro/courses',
    loadComponent: () => import('./features/courses/teacher-courses.component').then(m => m.TeacherCoursesComponent),
    canActivate: [authGuard, roleGuard],
    data: { roles: ['MAESTRO'] }
  },
  // Nueva ruta: detalle de curso desde Mis Cursos (maestro)
  {
    path: 'maestro/mis-cursos/curso/:id',
    loadComponent: () => import('./features/courses/maestro-curso-detalle.component').then(m => m.MaestroCursoDetalleComponent),
    canActivate: [authGuard, roleGuard],
    data: { roles: ['MAESTRO'] }
  },
  {
    path: 'admin/courses',
    loadComponent: () => import('./features/admin/course-admin-list.component').then(m => m.CourseAdminListComponent),
    canActivate: [authGuard, roleGuard],
    data: { roles: ['ADMIN'] }
  },
  {
    path: 'admin/courses/new',
    loadComponent: () => import('./features/admin/course-form.component').then(m => m.CourseFormComponent),
    canActivate: [authGuard, roleGuard],
    data: { roles: ['ADMIN', 'MAESTRO'] }
  },
  {
    path: 'admin/courses/:id/edit',
    loadComponent: () => import('./features/admin/course-form.component').then(m => m.CourseFormComponent),
    canActivate: [authGuard, roleGuard],
    data: { roles: ['ADMIN', 'MAESTRO'] }
  },
  {
    path: 'admin/users',
    loadComponent: () => import('./features/admin/user-admin-list.component').then(m => m.UserAdminListComponent),
    canActivate: [authGuard, roleGuard],
    data: { roles: ['ADMIN'] }
  },
  {
    path: 'admin/users/new',
    loadComponent: () => import('./features/admin/user-form.component').then(m => m.UserFormComponent),
    canActivate: [authGuard, roleGuard],
    data: { roles: ['ADMIN'] }
  },
  {
    path: 'admin/users/:id/edit',
    loadComponent: () => import('./features/admin/user-form.component').then(m => m.UserFormComponent),
    canActivate: [authGuard, roleGuard],
    data: { roles: ['ADMIN'] }
  },
  {
    path: 'users/profile',
    loadComponent: () => import('./features/users/profile.component').then(m => m.ProfileComponent),
    canActivate: [authGuard]
  },
  {
    path: 'users/change-password',
    loadComponent: () => import('./features/users/change-password.component').then(m => m.ChangePasswordComponent),
    canActivate: [authGuard]
  },
  {
    path: 'certificates/my',
    loadComponent: () => import('./features/certificates/my-certificates.component').then(m => m.MyCertificatesComponent),
    canActivate: [authGuard, roleGuard],
    data: { roles: ['ALUMNO'] }
  },
  {
    path: 'certificates/verify',
    loadComponent: () => import('./features/certificates/verify-certificate.component').then(m => m.VerifyCertificateComponent)
  },
  {
    path: 'parental/children',
    loadComponent: () => import('./features/parental/parental-children-list.component').then(m => m.ParentalChildrenListComponent),
    canActivate: [authGuard, roleGuard],
    data: { roles: ['PADRE'] }
  },
  {
    path: 'parental/children/:childId',
    loadComponent: () => import('./features/parental/child-progress.component').then(m => m.ChildProgressComponent),
    canActivate: [authGuard, roleGuard],
    data: { roles: ['PADRE'] }
  },
  {
    path: 'parental/settings',
    loadComponent: () => import('./features/parental/parental-settings.component').then(m => m.ParentalSettingsComponent),
    canActivate: [authGuard, roleGuard],
    data: { roles: ['PADRE'] }
  },
  // Achievements Routes
  {
    path: 'alumno/achievements',
    loadComponent: () => import('./features/achievements/student-achievements.component').then(m => m.StudentAchievementsComponent),
    canActivate: [authGuard, roleGuard],
    data: { roles: ['ALUMNO'] }
  },
  {
    path: 'admin/achievements',
    loadComponent: () => import('./features/achievements/achievement-admin-list.component').then(m => m.AchievementAdminListComponent),
    canActivate: [authGuard, roleGuard],
    data: { roles: ['ADMIN'] }
  },
  {
    path: 'admin/achievements/new',
    loadComponent: () => import('./features/achievements/achievement-form.component').then(m => m.AchievementFormComponent),
    canActivate: [authGuard, roleGuard],
    data: { roles: ['ADMIN'] }
  },
  {
    path: 'admin/achievements/:id/edit',
    loadComponent: () => import('./features/achievements/achievement-form.component').then(m => m.AchievementFormComponent),
    canActivate: [authGuard, roleGuard],
    data: { roles: ['ADMIN'] }
  },
  // Tech Posts Routes
  {
    path: 'tech',
    loadComponent: () => import('./features/tech-posts/tech-post-list.component').then(m => m.TechPostListComponent)
  },
  {
    path: 'tech/:slug',
    loadComponent: () => import('./features/tech-posts/tech-post-detail.component').then(m => m.TechPostDetailComponent)
  },
  {
    path: 'admin/tech-posts',
    loadComponent: () => import('./features/tech-posts/tech-post-admin-list.component').then(m => m.TechPostAdminListComponent),
    canActivate: [authGuard, roleGuard],
    data: { roles: ['ADMIN', 'MAESTRO'] }
  },
  {
    path: 'admin/tech-posts/new',
    loadComponent: () => import('./features/tech-posts/tech-post-form.component').then(m => m.TechPostFormComponent),
    canActivate: [authGuard, roleGuard],
    data: { roles: ['ADMIN', 'MAESTRO'] }
  },
  {
    path: 'admin/tech-posts/:id/edit',
    loadComponent: () => import('./features/tech-posts/tech-post-form.component').then(m => m.TechPostFormComponent),
    canActivate: [authGuard, roleGuard],
    data: { roles: ['ADMIN', 'MAESTRO'] }
  },
  {
    path: '**',
    loadComponent: () => import('./shared/components/not-found.component').then(m => m.NotFoundComponent)
  }
];

