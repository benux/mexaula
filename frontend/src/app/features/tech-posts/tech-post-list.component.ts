import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterModule } from '@angular/router';
import { TechPostService } from '../../core/services/tech-post.service';
import { TechPost } from '../../core/models/tech-post.model';

@Component({
  selector: 'app-tech-post-list',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './tech-post-list.component.html'
})
export class TechPostListComponent implements OnInit {
  posts: TechPost[] = [];
  loading = false;
  error = '';

  constructor(
    private readonly techPostService: TechPostService,
    private readonly router: Router
  ) {}

  ngOnInit(): void {
    this.loadPosts();
  }

  loadPosts(): void {
    this.loading = true;
    this.error = '';
    this.techPostService.getPublished().subscribe({
      next: (data) => {
        this.posts = data;
        this.loading = false;
      },
      error: (err) => {
        this.error = 'Error al cargar las publicaciones';
        this.loading = false;
        console.error(err);
      }
    });
  }

  viewPost(slug: string): void {
    this.router.navigate(['/tech', slug]);
  }

  getCategoryColor(categoria: string | null): string {
    if (!categoria) return 'bg-gray-100 text-gray-800';

    const colors: { [key: string]: string } = {
      'frontend': 'bg-blue-100 text-blue-800',
      'backend': 'bg-green-100 text-green-800',
      'devops': 'bg-purple-100 text-purple-800',
      'database': 'bg-yellow-100 text-yellow-800',
      'security': 'bg-red-100 text-red-800'
    };

    return colors[categoria.toLowerCase()] || 'bg-gray-100 text-gray-800';
  }
}

