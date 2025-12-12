import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, Validators, ReactiveFormsModule } from '@angular/forms';
import { CertificateService } from '../../core/services/certificate.service';
import { Certificate } from '../../core/models/certificate.model';
import { NotificationService } from '../../core/services/notification.service';

@Component({
  selector: 'app-verify-certificate',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './verify-certificate.component.html'
})
export class VerifyCertificateComponent {
  verifyForm: FormGroup;
  isLoading = false;
  certificate: Certificate | null = null;
  notFound = false;

  constructor(
    private fb: FormBuilder,
    private certificateService: CertificateService,
    private notificationService: NotificationService
  ) {
    this.verifyForm = this.fb.group({
      code: ['', Validators.required]
    });
  }

  onSubmit(): void {
    if (this.verifyForm.valid) {
      this.isLoading = true;
      this.certificate = null;
      this.notFound = false;

      const code = this.verifyForm.value.code;

      this.certificateService.verify(code).subscribe({
        next: (cert) => {
          this.certificate = cert;
          this.isLoading = false;
          this.notificationService.success('Certificado verificado exitosamente');
        },
        error: () => {
          this.notFound = true;
          this.isLoading = false;
        }
      });
    }
  }
}
