import { CourseLevel } from './course.model';

export interface ParentalLink {
  id: number;
  padreId: number;
  alumnoId: number;
  creadoEn: string;
  alumnoNombre: string;
}

export interface ParentalSettings {
  id: number;
  padreId: number;
  nivelMaximoContenido: CourseLevel | null;
  tiempoMaximoDiarioMin: number | null;
  creadoEn: string;
  actualizadoEn: string;
}

export interface ChildProgress {
  childId: number;
  childNombre: string;
  cursos: {
    cursoId: number;
    titulo: string;
    progresoPorcentaje: number;
    completado: boolean;
  }[];
}

