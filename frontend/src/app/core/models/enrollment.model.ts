export interface Enrollment {
  id: number;
  cursoId: number;
  alumnoId: number;
  progresoPorcentaje: number;
  completado: boolean;
  inscritoEn: string;
  actualizadoEn: string;
}

export interface UpdateProgressRequest {
  progresoPorcentaje: number;
  completado?: boolean;
}

