export type TechPostStatus = 'DRAFT' | 'PUBLISHED';

export interface TechPost {
  id: number;
  titulo: string;
  resumen: string;
  contenidoMarkdown: string;
  slug: string;
  categoria: string | null;
  etiquetas: string[];
  estado: TechPostStatus;
  autorId: number;
  autorNombre: string;
  creadoEn: string;
  actualizadoEn: string;
}

