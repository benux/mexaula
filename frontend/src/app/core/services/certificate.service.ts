import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Certificate, GenerateCertificateRequest } from '../models/certificate.model';
import { environment } from '../../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class CertificateService {
  private readonly API_URL = `${environment.apiUrl}/certificates`;

  constructor(private http: HttpClient) {}

  getMyCertificates(): Observable<Certificate[]> {
    return this.http.get<Certificate[]>(`${this.API_URL}/my`);
  }

  generate(courseId: number): Observable<Certificate> {
    const payload: GenerateCertificateRequest = { cursoId: courseId };
    return this.http.post<Certificate>(this.API_URL, payload);
  }

  verify(code: string): Observable<Certificate> {
    return this.http.get<Certificate>(`${this.API_URL}/verify/${code}`);
  }
}

