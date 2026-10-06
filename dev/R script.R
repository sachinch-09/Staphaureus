# ─────────────────────────────────────────────────────────────
# Box & Whisker plots: Top 10 vs remaining transporter families
# Excludes: ABC, GPTS (PTS), SSPTS (PTS), Total row
# ─────────────────────────────────────────────────────────────

library(readxl)
library(tidyverse)
library(scales)

# ── 1. Import ─────────────────────────────────────────────────
df <- read_excel("data/Data table.xlsx")

# ── 2. Clean: extract genome names, drop excluded columns ─────
genome_col <- colnames(df)[1]

exclude_cols <- c(
  genome_col, "Unnamed: 103", "Total Transporters",
  "ABC", "GPTS", "SSPTS"
)

df_clean <- df |>
  mutate(Genome = gsub(".*/|\\.[^.]+$", "", .data[[genome_col]])) |>
  filter(!grepl("^Total$", Genome, ignore.case = TRUE)) |>
  select(-any_of(setdiff(exclude_cols, "Genome"))) |>
  mutate(across(-Genome, as.numeric))

# ── 3. Pivot to long (tidy) format ────────────────────────────
df_long <- df_clean |>
  pivot_longer(cols      = -Genome,
               names_to  = "Transporter_Family",
               values_to = "Count") |>
  filter(!is.na(Count))

# ── 4. Summarise to get median per family (for ordering) ──────
family_order <- df_long |>
  group_by(Transporter_Family) |>
  summarise(med = median(Count, na.rm = TRUE)) |>
  arrange(desc(med)) |>
  pull(Transporter_Family)

# ── 5. Split into top 10 and the rest ─────────────────────────
top10  <- family_order[1:10]
rest   <- family_order[11:length(family_order)]

df_top10 <- df_long |>
  filter(Transporter_Family %in% top10) |>
  mutate(Transporter_Family = factor(Transporter_Family, levels = top10))

df_rest <- df_long |>
  filter(Transporter_Family %in% rest) |>
  mutate(Transporter_Family = factor(Transporter_Family, levels = rest))

# ── 6. Shared theme ───────────────────────────────────────────
box_theme <- function() {
  theme_classic() +
    theme(
      plot.title      = element_text(face = "bold", size = 13, hjust = 0),
      plot.subtitle   = element_text(size = 9, colour = "grey40", hjust = 0),
      plot.caption    = element_text(size = 8, colour = "grey50"),
      axis.text.x     = element_text(angle = 45, hjust = 1, vjust = 1, size = 9),
      axis.text.y     = element_text(size = 9),
      axis.title      = element_text(face = "bold"),
      legend.position = "none",
      plot.margin     = margin(10, 15, 10, 10)
    )
}

n_genomes <- length(unique(df_long$Genome))

# ── 7a. Plot: Top 10 transporter families ─────────────────────
fig_top10 <- ggplot() +
  geom_boxplot(data = df_top10,
               aes(x = Transporter_Family, y = Count,
                   fill = Transporter_Family),
               outlier.shape  = 21,
               outlier.size   = 1.8,
               outlier.colour = "grey40",
               outlier.fill   = "white",
               linewidth      = 0.5,
               width          = 0.65,
               colour         = "grey20") +
  scale_fill_manual(
    values = colorRampPalette(
      c("#4E79A7","#F28E2B","#E15759","#76B7B2","#59A14F",
        "#EDC948","#B07AA1","#FF9DA7","#9C755F","#BAB0AC")
    )(10)
  ) +
  scale_y_continuous(name   = "Count per Genome",
                     breaks = pretty_breaks(n = 8),
                     expand = expansion(mult = c(0.02, 0.08))) +
  scale_x_discrete(name = "Transporter Family") +
  labs(
    title    = "Top 10 Transporter Families by Median Count",
    subtitle = "ABC and PTS (GPTS, SSPTS) excluded  |  ordered by median",
    caption  = paste0("n = ", n_genomes, " genomes  |  box = IQR, whiskers = 1.5 × IQR, dots = outliers")
  ) +
  box_theme()

# ── 7b. Plot: Remaining transporter families ──────────────────
fig_rest <- ggplot() +
  geom_boxplot(data = df_rest,
               aes(x = Transporter_Family, y = Count,
                   fill = Transporter_Family),
               outlier.shape  = 21,
               outlier.size   = 1.5,
               outlier.colour = "grey40",
               outlier.fill   = "white",
               linewidth      = 0.45,
               width          = 0.65,
               colour         = "grey20") +
  scale_fill_manual(
    values = colorRampPalette(
      c("#4E79A7","#F28E2B","#E15759","#76B7B2","#59A14F",
        "#EDC948","#B07AA1","#FF9DA7","#9C755F","#BAB0AC")
    )(length(rest))
  ) +
  scale_y_continuous(name   = "Count per Genome",
                     breaks = pretty_breaks(n = 8),
                     expand = expansion(mult = c(0.02, 0.08))) +
  scale_x_discrete(name = "Transporter Family") +
  labs(
    title    = paste0("Remaining ", length(rest), " Transporter Families"),
    subtitle = "ABC and PTS (GPTS, SSPTS) excluded  |  ordered by median",
    caption  = paste0("n = ", n_genomes, " genomes  |  box = IQR, whiskers = 1.5 × IQR, dots = outliers")
  ) +
  box_theme() +
  theme(axis.text.x = element_text(angle = 55, hjust = 1, vjust = 1, size = 7.5))

# ── 8. View both plots ────────────────────────────────────────
fig_top10
fig_rest

# ── 9. Save ───────────────────────────────────────────────────
ggsave("figures/transporter_top10.png",
       plot   = fig_top10,
       device = "png",
       width  = 10,
       height = 6,
       units  = "in",
       dpi    = 300)

ggsave("figures/transporter_rest.png",
       plot   = fig_rest,
       device = "png",
       width  = 22,
       height = 7,
       units  = "in",
       dpi    = 300)
