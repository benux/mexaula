import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router } from '@angular/router';
import { ParentalControlService } from '../../core/services/parental-control.service';
import { ChildProgress } from '../../core/models/parental.model';

@Component({
  selector: 'app-child-progress',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './child-progress.component.html'
})
export class ChildProgressComponent implements OnInit {
  progress: ChildProgress | null = null;
  isLoading = false;
  childId: number | null = null;

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private parentalService: ParentalControlService
  ) {}

  ngOnInit(): void {
    const id = this.route.snapshot.paramMap.get('childId');
    if (id) {
      this.childId = +id;
      this.loadProgress(this.childId);
    }
  }

  loadProgress(childId: number): void {
    this.isLoading = true;
    this.parentalService.getChildProgress(childId).subscribe({
      next: (progress) => {
        this.progress = progress;
        this.isLoading = false;
      },
      error: () => {
        this.isLoading = false;
      }
    });
  }

  getCompletedCount(): number {
    return this.progress?.cursos.filter(c => c.completado).length || 0;
  }

  getAverageProgress(): number {
    if (!this.progress || this.progress.cursos.length === 0) return 0;
    const total = this.progress.cursos.reduce((sum, c) => sum + c.progresoPorcentaje, 0);
    return Math.round(total / this.progress.cursos.length);
  }

  goBack(): void {
    this.router.navigate(['/parental/children']);
  }
}
