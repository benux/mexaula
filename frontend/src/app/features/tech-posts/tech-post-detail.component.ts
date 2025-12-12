import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router } from '@angular/router';
import { TechPostService } from '../../core/services/tech-post.service';
import { TechPost } from '../../core/models/tech-post.model';
@Component({
  selector: 'app-tech-post-detail',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './tech-post-detail.component.html'
})
export class TechPostDetailComponent implements OnInit {
  post?: TechPost;
  loading = false;
  error = '';
  constructor(
    private readonly techPostService: TechPostService,
    private readonly route: ActivatedRoute,
    private readonly router: Router
  ) {}
  ngOnInit(): void {
    const slug = this.route.snapshot.paramMap.get('slug');
    if (slug) {
      this.loadPost(slug);
    }
  }
  loadPost(slug: string): void {
    this.loading = true;
    this.error = '';
    this.techPostService.getBySlug(slug).subscribe({
      next: (data) => {
        this.post = data;
        this.loading = false;
      },
      error: (err) => {
        this.error = 'Error al cargar la publicación';
        this.loading = false;
        console.error(err);
      }
    });
  }
  goBack(): void {
    this.router.navigate(['/tech']);
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
