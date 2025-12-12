export type Role = 'ADMIN' | 'PADRE' | 'MAESTRO' | 'ALUMNO';

export interface User {
  id: number;
  nombre: string;
  apellido: string;
  email: string;
  activo: boolean;
  roles: Role[];
}

export interface LoginRequest {
  email: string;
  password: string;
}

export interface LoginResponse {
  token: string;
  user: User;
}

export interface RegisterRequest {
  nombre: string;
  apellido: string;
  email: string;
  password: string;
  rolDeseado?: 'ALUMNO' | 'PADRE';
}

export interface ChangePasswordRequest {
  currentPassword: string;
  newPassword: string;
}

