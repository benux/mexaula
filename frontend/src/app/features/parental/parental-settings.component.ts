import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, ReactiveFormsModule } from '@angular/forms';
import { ParentalControlService } from '../../core/services/parental-control.service';
import { ParentalSettings } from '../../core/models/parental.model';
import { NotificationService } from '../../core/services/notification.service';

@Component({
  selector: 'app-parental-settings',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './parental-settings.component.html'
})
export class ParentalSettingsComponent implements OnInit {
  settingsForm: FormGroup;
  isLoading = false;
  isSaving = false;
  currentSettings: ParentalSettings | null = null;

  constructor(
    private fb: FormBuilder,
    private parentalService: ParentalControlService,
    private notificationService: NotificationService
  ) {
    this.settingsForm = this.fb.group({
      nivelMaximoContenido: [null],
      tiempoMaximoDiarioMin: [null]
    });
  }

  ngOnInit(): void {
    this.loadSettings();
  }

  loadSettings(): void {
    this.isLoading = true;
    this.parentalService.getSettings().subscribe({
      next: (settings) => {
        this.currentSettings = settings;
        this.settingsForm.patchValue({
          nivelMaximoContenido: settings.nivelMaximoContenido,
          tiempoMaximoDiarioMin: settings.tiempoMaximoDiarioMin
        });
        this.isLoading = false;
      },
      error: () => {
        this.isLoading = false;
      }
    });
  }

  onSubmit(): void {
    if (this.settingsForm.valid) {
      this.isSaving = true;
      const payload = this.settingsForm.value;

      this.parentalService.updateSettings(payload).subscribe({
        next: () => {
          this.notificationService.success('Configuración actualizada exitosamente');
          this.isSaving = false;
          this.loadSettings();
        },
        error: () => {
          this.isSaving = false;
        }
      });
    }
  }

  resetForm(): void {
    if (this.currentSettings) {
      this.settingsForm.patchValue({
        nivelMaximoContenido: this.currentSettings.nivelMaximoContenido,
        tiempoMaximoDiarioMin: this.currentSettings.tiempoMaximoDiarioMin
      });
    }
  }
}
