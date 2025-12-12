import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { ParentalLink, ParentalSettings, ChildProgress } from '../models/parental.model';
import { environment } from '../../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class ParentalControlService {
  private readonly API_URL = `${environment.apiUrl}/parental`;

  constructor(private http: HttpClient) {}

  getChildren(): Observable<ParentalLink[]> {
    return this.http.get<ParentalLink[]>(`${this.API_URL}/children`);
  }

  getChildProgress(childId: number): Observable<ChildProgress> {
    return this.http.get<ChildProgress>(`${this.API_URL}/children/${childId}/progress`);
  }

  getSettings(): Observable<ParentalSettings> {
    return this.http.get<ParentalSettings>(`${this.API_URL}/settings`);
  }

  updateSettings(payload: Partial<ParentalSettings>): Observable<ParentalSettings> {
    return this.http.put<ParentalSettings>(`${this.API_URL}/settings`, payload);
  }
}

