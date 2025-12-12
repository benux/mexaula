import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { CertificateService } from '../../core/services/certificate.service';
import { Certificate } from '../../core/models/certificate.model';
import { NotificationService } from '../../core/services/notification.service';

@Component({
  selector: 'app-my-certificates',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './my-certificates.component.html'
})
export class MyCertificatesComponent implements OnInit {
  certificates: Certificate[] = [];
  isLoading = false;

  constructor(
    private certificateService: CertificateService,
    private notificationService: NotificationService
  ) {}

  ngOnInit(): void {
    this.loadCertificates();
  }

  loadCertificates(): void {
    this.isLoading = true;
    this.certificateService.getMyCertificates().subscribe({
      next: (certs) => {
        this.certificates = certs;
        this.isLoading = false;
      },
      error: () => {
        this.isLoading = false;
      }
    });
  }

  downloadCertificate(cert: Certificate): void {
    this.notificationService.info('Descarga de certificado en desarrollo');
    // TODO: Implement PDF generation/download
  }
}
