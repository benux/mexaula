export type CourseLevel = 'BASICO' | 'INTERMEDIO' | 'AVANZADO';

export interface Course {
  id: number;
  titulo: string;
  descripcion: string;
  nivel: CourseLevel;
  publicado: boolean;
  maestroId: number;
  maestroNombre?: string;
  creadoEn: string;
  actualizadoEn: string;
}

export interface CreateCourseRequest {
  titulo: string;
  descripcion: string;
  nivel: CourseLevel;
  publicado: boolean;
  maestroId?: number;
}

export interface UpdateCourseRequest {
  titulo: string;
  descripcion: string;
  nivel: CourseLevel;
  publicado: boolean;
}

