import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AchievementService } from '../../core/services/achievement.service';
import { UserAchievement } from '../../core/models/achievement.model';

@Component({
  selector: 'app-student-achievements',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './student-achievements.component.html'
})
export class StudentAchievementsComponent implements OnInit {
  achievements: UserAchievement[] = [];
  loading = false;
  error = '';

  constructor(private readonly achievementService: AchievementService) {}

  ngOnInit(): void {
    this.loadAchievements();
  }

  loadAchievements(): void {
    this.loading = true;
    this.error = '';
    this.achievementService.getMyAchievements().subscribe({
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

  shareAchievement(achievement: UserAchievement, platform: 'twitter' | 'linkedin' | 'facebook'): void {
    const text = `¡He conseguido el logro "${achievement.logro.titulo}"! 🎉`;
    const url = globalThis.location.href;

    let shareUrl = '';

    switch (platform) {
      case 'twitter':
        shareUrl = `https://twitter.com/intent/tweet?text=${encodeURIComponent(text)}&url=${encodeURIComponent(url)}`;
        break;
      case 'linkedin':
        shareUrl = `https://www.linkedin.com/sharing/share-offsite/?url=${encodeURIComponent(url)}`;
        break;
      case 'facebook':
        shareUrl = `https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(url)}`;
        break;
    }

    if (shareUrl) {
      globalThis.open(shareUrl, '_blank', 'width=600,height=400');

      // Incrementar contador en el backend
      this.achievementService.incrementShared(achievement.id).subscribe({
        next: () => {
          achievement.compartidoVeces++;
        },
        error: (err) => console.error('Error al incrementar contador', err)
      });
    }
  }
}

