export interface Certificate {
  id: number;
  alumnoId: number;
  cursoId: number;
  cursoTitulo: string;
  codigoVerificacion: string;
  fechaEmision: string;
}

export interface GenerateCertificateRequest {
  cursoId: number;
}

