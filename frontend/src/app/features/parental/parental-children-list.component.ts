import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { ParentalControlService } from '../../core/services/parental-control.service';
import { ParentalLink } from '../../core/models/parental.model';

@Component({
  selector: 'app-parental-children-list',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './parental-children-list.component.html'
})
export class ParentalChildrenListComponent implements OnInit {
  children: ParentalLink[] = [];
  isLoading = false;

  constructor(private parentalService: ParentalControlService) {}

  ngOnInit(): void {
    this.loadChildren();
  }

  loadChildren(): void {
    this.isLoading = true;
    this.parentalService.getChildren().subscribe({
      next: (children) => {
        this.children = children;
        this.isLoading = false;
      },
      error: () => {
        this.isLoading = false;
      }
    });
  }
}
