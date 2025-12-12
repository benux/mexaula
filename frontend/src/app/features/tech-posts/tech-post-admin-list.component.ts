import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterModule } from '@angular/router';
import { TechPostService } from '../../core/services/tech-post.service';
import { TechPost } from '../../core/models/tech-post.model';

@Component({
  selector: 'app-tech-post-admin-list',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './tech-post-admin-list.component.html'
})
export class TechPostAdminListComponent implements OnInit {
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
    this.techPostService.getAllForAdmin().subscribe({
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

  deletePost(id: number): void {
    if (!confirm('¿Estás seguro de que quieres eliminar esta publicación?')) {
      return;
    }

    this.techPostService.delete(id).subscribe({
      next: () => {
        this.posts = this.posts.filter(p => p.id !== id);
      },
      error: (err) => {
        this.error = 'Error al eliminar la publicación';
        console.error(err);
      }
    });
  }

  editPost(id: number): void {
    this.router.navigate(['/admin/tech-posts', id, 'edit']);
  }

  createNew(): void {
    this.router.navigate(['/admin/tech-posts/new']);
  }
}

