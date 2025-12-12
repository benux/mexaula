export type AchievementType = 'SYSTEM' | 'CUSTOM';

export interface Achievement {
  id: number;
  titulo: string;
  descripcion: string;
  iconoUrl: string | null;
  tipo: AchievementType;
  criterioCodigo: string;
  puntos: number;
  activo: boolean;
  creadoEn: string;
  actualizadoEn: string;
}

export interface UserAchievement {
  id: number;
  logroId: number;
  alumnoId: number;
  fechaObtenido: string;
  compartidoVeces: number;
  logro: Achievement;
}

