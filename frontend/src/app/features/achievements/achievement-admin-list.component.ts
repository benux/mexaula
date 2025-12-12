import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterModule } from '@angular/router';
import { AchievementService } from '../../core/services/achievement.service';
import { Achievement } from '../../core/models/achievement.model';

@Component({
  selector: 'app-achievement-admin-list',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './achievement-admin-list.component.html'
})
export class AchievementAdminListComponent implements OnInit {
  achievements: Achievement[] = [];
  loading = false;
  error = '';

  constructor(
    private readonly achievementService: AchievementService,
    private readonly router: Router
  ) {}

  ngOnInit(): void {
    this.loadAchievements();
  }

  loadAchievements(): void {
    this.loading = true;
    this.error = '';
    this.achievementService.getAll().subscribe({
      next: (data) => {
        this.achievements = data;
        this.loading = false;
      },
      error: (err) => {
        this.error = 'Error al cargar logros';
        this.loading = false;
        console.error(err);
      }
    });
  }

  deleteAchievement(id: number): void {
    if (!confirm('¿Estás seguro de que quieres eliminar este logro?')) {
      return;
    }

    this.achievementService.delete(id).subscribe({
      next: () => {
        this.achievements = this.achievements.filter(a => a.id !== id);
      },
      error: (err) => {
        this.error = 'Error al eliminar el logro';
        console.error(err);
      }
    });
  }

  editAchievement(id: number): void {
    this.router.navigate(['/admin/achievements', id, 'edit']);
  }

  createNew(): void {
    this.router.navigate(['/admin/achievements/new']);
  }
}

