import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { AchievementService } from '../../core/services/achievement.service';
import { AchievementType } from '../../core/models/achievement.model';

@Component({
  selector: 'app-achievement-form',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './achievement-form.component.html'
})
export class AchievementFormComponent implements OnInit {
  achievementForm: FormGroup;
  loading = false;
  error = '';
  isEditMode = false;
  achievementId?: number;

  achievementTypes: AchievementType[] = ['SYSTEM', 'CUSTOM'];

  constructor(
    private readonly fb: FormBuilder,
    private readonly achievementService: AchievementService,
    private readonly router: Router,
    private readonly route: ActivatedRoute
  ) {
    this.achievementForm = this.fb.group({
      titulo: ['', [Validators.required, Validators.maxLength(100)]],
      descripcion: ['', [Validators.required]],
      iconoUrl: [''],
      tipo: ['SYSTEM', Validators.required],
      criterioCodigo: ['', [Validators.required, Validators.maxLength(50)]],
      puntos: [0, [Validators.required, Validators.min(0)]],
      activo: [true]
    });
  }

  ngOnInit(): void {
    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      this.isEditMode = true;
      this.achievementId = Number.parseInt(id, 10);
      this.loadAchievement(this.achievementId);
    }
  }

  loadAchievement(id: number): void {
    this.loading = true;
    this.achievementService.getById(id).subscribe({
      next: (achievement) => {
        this.achievementForm.patchValue(achievement);
        this.loading = false;
      },
      error: (err) => {
        this.error = 'Error al cargar el logro';
        this.loading = false;
        console.error(err);
      }
    });
  }

  onSubmit(): void {
    if (this.achievementForm.invalid) {
      return;
    }

    this.loading = true;
    this.error = '';

    const formValue = this.achievementForm.value;

    const request = this.isEditMode
      ? this.achievementService.update(this.achievementId!, formValue)
      : this.achievementService.create(formValue);

    request.subscribe({
      next: () => {
        this.router.navigate(['/admin/achievements']);
      },
      error: (err) => {
        this.error = this.isEditMode
          ? 'Error al actualizar el logro'
          : 'Error al crear el logro';
        this.loading = false;
        console.error(err);
      }
    });
  }

  cancel(): void {
    this.router.navigate(['/admin/achievements']);
  }
}

