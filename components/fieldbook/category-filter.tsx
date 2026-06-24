import type { FieldbookCategory } from "@/lib/fieldbook/types";

type CategorySelection = "All" | FieldbookCategory;

type Props = {
  categories: readonly FieldbookCategory[];
  selected: CategorySelection;
  onSelect: (category: CategorySelection) => void;
};

export function CategoryFilter({ categories, selected, onSelect }: Props) {
  const options: readonly CategorySelection[] = ["All", ...categories];

  return (
    <div aria-label="Filter Fieldbook articles by category" className="flex flex-wrap gap-2" role="group">
      {options.map((category) => <button aria-pressed={selected === category} className={`rounded-full border px-3 py-1.5 text-sm font-medium ${selected === category ? "border-slate-900 bg-slate-900 text-white" : "border-slate-300 bg-white text-slate-600 hover:bg-slate-50"}`} key={category} onClick={() => onSelect(category)} type="button">{category}</button>)}
    </div>
  );
}
