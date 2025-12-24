# MG-0003 픽셀 용병단 키우기 - 구현 상태

> 마지막 업데이트: 2025-12-18
> 전체 진행률: **90%**

---

## 📊 전체 요약

| 영역 | 완료율 | 상태 |
|------|--------|------|
| 코어 시스템 | 95% | ✅ 완료 |
| 전투 시스템 | 100% | ✅ 완료 |
| UI/UX | 85% | ✅ 거의 완료 |
| 에셋 | 0% | ⏳ 대기 |
| 방치 시스템 | 50% | 🔄 부분 완료 |

---

## ✅ 완료된 기능 (Completed Features)

### 1. 영웅 시스템 (100%)

#### HeroData 모델
- ✅ 3가지 역할 정의 (Tank, Archer, Healer)
- ✅ 스탯 시스템 (HP, ATK, DEF)
- ✅ BaseStat 활용 (mg_common_game)
- ✅ 레벨업 시스템
  - Level++
  - HP/ATK +10% per level
  - DEF +1 per level

**파일**: `lib/game/data/hero_data.dart`

#### HeroEntity 컴포넌트
- ✅ Flame 컴포넌트로 구현
- ✅ HP 바 렌더링
- ✅ 피격/힐 시스템
- ✅ 사망/리스폰 로직
- ✅ 역할별 행동 패턴
  - Tank: 근접 방어
  - Archer: 원거리 크리티컬 공격 (range: 300)
  - Healer: 아군 HP 회복

**파일**: `lib/game/entities/hero.dart`

### 2. 몬스터 시스템 (100%)

#### MonsterEntity 컴포넌트
- ✅ 일반/보스 몬스터 분류
- ✅ HP 스케일링 (stage에 따라 증가)
- ✅ 보스: 5배 HP, 5배 보상
- ✅ HP 바 렌더링
- ✅ 피격/사망 시스템
- ✅ 이동 AI (영웅을 향해 이동)

**파일**: `lib/game/entities/monster.dart`

### 3. 전투 시스템 (100%)

#### BattleGame (자동 전투)
- ✅ Flame 게임 루프
- ✅ 영웅 파티 스폰 (위치 자동 배치)
- ✅ 몬스터 자동 스폰 (2초 간격)
- ✅ 전투 로직
  - 영웅 → 몬스터 공격 (역할별 차별화)
  - 몬스터 → 영웅 공격 (근접 시)
  - 힐러 → 아군 힐링 (HP 가장 낮은 대상)
- ✅ 거리 계산 및 범위 공격
  - 궁수: 300px 원거리
  - 탱커/힐러: 80px 근접
  - 몬스터: 50px 근접
- ✅ 크리티컬 표시 (궁수 공격)
- ✅ FloatingText 피해량 표시
- ✅ 골드 드롭 (일반 +10, 보스 +50)

**파일**: `lib/game/battle_game.dart`

### 4. UI 시스템 (85%)

#### HeroManagementPanel
- ✅ 하단 영웅 관리 패널 (40% 화면)
- ✅ 영웅 목록 표시
  - 이름, 레벨, HP/ATK/DEF
  - HP 바 시각화
- ✅ 레벨업 버튼
  - 비용: 50 골드
  - 실시간 골드 반영
- ✅ 힐러 고용 버튼
  - 비용: 1000 골드
  - 중복 고용 방지
- ✅ StreamBuilder로 실시간 UI 업데이트

**파일**: `lib/ui/hero_management_panel.dart`

#### StageInfoOverlay
- ✅ 상단 스테이지 정보 표시
- ✅ 현재 스테이지 번호
- ✅ 처치 수 / 보스까지 남은 수
- ✅ 반투명 배경

**파일**: `lib/ui/stage_info_overlay.dart`

### 5. 게임 매니저 (100%)

#### GameManager
- ✅ ChangeNotifier 기반 상태 관리
- ✅ 영웅 파티 관리 (List<HeroData>)
- ✅ 초기 파티 설정 (기사 + 궁수)
- ✅ 영웅 업그레이드 (levelUp)
- ✅ 힐러 고용 (recruitHealer)
- ✅ 골드 소비 검증

**파일**: `lib/game/logic/game_manager.dart`

#### StageManager
- ✅ 스테이지 진행 관리
- ✅ 몬스터 처치 카운트
- ✅ 보스 스폰 로직 (10마리마다)
- ✅ 몬스터 HP 스케일링 (stage에 따라 증가)
- ✅ 스테이지 클리어 조건 (보스 처치)

**파일**: `lib/game/logic/stage_manager.dart`

### 6. 의존성 주입 (100%)

#### GetIt Setup
- ✅ GoldManager 싱글톤
- ✅ GameManager 싱글톤
- ✅ StageManager 싱글톤
- ✅ AudioManager 싱글톤

**파일**: `lib/main.dart:setupDependencies()`

---

## 🔄 부분 완료 기능 (Partially Complete)

### 방치 시스템 (90%)
### 방치 시스템 (100%)
- ✅ 전투 자동 진행 (Auto-Battle)
- ✅ 골드 자동 획득
- ✅ 오프라인 보상 구현 (Offline Rewards)
- ✅ 시간당 보상 계산 로직
- ✅ 마지막 로그인 시간 저장 (SaveManager)
- ✅ 복귀 보상 팝업 구현 (OfflineRewardDialog)

### 스탯 시스템 (70%)

### 장비 시스템 (80%)
- ✅ 장비 데이터 모델 (Equipment, Rarity)
- ✅ 인벤토리 로직 (InventoryLogic)
- ✅ 장비 착용/해제 (HeroData Integration)
- ✅ 몬스터 처치 시 드랍 (10% 확률)
- ✅ UI: 장비 슬롯 및 장착 팝업
- ⏳ 장비 강화/합성 미구현
- ⏳ 장비 아이콘 에셋 미구현 (Placeholder 사용)

### 스탯 시스템 (90%)
- ✅ BaseStat 활용 (HP, ATK, DEF)
- ✅ 장비 스탯 반영 (HeroData.currentStats)
- ✅ 레벨업 성장
- ⏳ 장비 스탯 보너스 미구현
- ⏳ 버프/디버프 시스템 미구현

---

## ⏳ 미완성 기능 (Pending Features)

### 1. 에셋 (50%)
- ✅ 영웅 스프라이트 3개 (생성 완료)
- ✅ 몬스터 스프라이트 2개 (생성 완료)
- ✅ 배경 이미지 1개 (생성 완료)
- ✅ UI 아이콘 2개 (생성 완료)
- ⏳ 사운드 효과 6개 (Placeholder)
- ⏳ BGM 1개 (Placeholder)

**참고**: `game/assets/images/` 폴더에 이미지 에셋 배치 완료.

### 2. 방치 수익 시스템 (0%)
- ⏳ 마지막 로그인 시간 저장
- ⏳ 오프라인 경과 시간 계산
- ⏳ 시간당 골드/경험치 보상
- ⏳ 복귀 보상 팝업

### 3. 장비 시스템 (100%)
- ✅ 장비 데이터 모델 (Data Model)
- ✅ 장비 장착/해제 로직 (InventoryLogic)
- ✅ 장비 드롭 시스템 (BattleGame)
- ✅ 장비 관리 UI (InventoryDialog)
- ✅ 장비 강화 시스템 (Upgrade System)

### 4. 추가 콘텐츠 (0%)
- ⏳ 더 많은 영웅 직업 (Mage, Assassin, Buffer)
- ⏳ 다양한 몬스터 종류
- ⏳ 여러 스테이지 배경
- ⏳ 보스 패턴 다양화

---

## 📁 핵심 파일 구조

```
mg-game-0003/
├─ game/
│  ├─ lib/
│  │  ├─ main.dart                          # ✅ 앱 진입점, DI 설정
│  │  ├─ game/
│  │  │  ├─ battle_game.dart               # ✅ 메인 게임 루프
│  │  │  ├─ data/
│  │  │  │  └─ hero_data.dart              # ✅ 영웅 데이터 모델
│  │  │  ├─ entities/
│  │  │  │  ├─ hero.dart                   # ✅ 영웅 엔티티
│  │  │  │  └─ monster.dart                # ✅ 몬스터 엔티티
│  │  │  └─ logic/
│  │  │     ├─ game_manager.dart           # ✅ 게임 매니저
│  │  │     └─ stage_manager.dart          # ✅ 스테이지 매니저
│  │  └─ ui/
│  │     ├─ hero_management_panel.dart     # ✅ 영웅 관리 UI
│  │     └─ stage_info_overlay.dart        # ✅ 스테이지 정보 UI
│  └─ assets/                               # ⏳ 에셋 폴더 (비어있음)
├─ docs/
│  ├─ design/
│  │  └─ gdd_game_0003.json                # ✅ GDD
│  ├─ fun_design.md                        # ✅ 재미 디자인 문서
│  ├─ bm_design.md                         # ✅ 비즈니스 모델 문서
│  └─ monetization_design.md               # ✅ 수익화 설계 문서
├─ ASSET_GENERATION_PROMPTS.md             # ✅ 에셋 생성 가이드 (신규)
├─ IMPLEMENTATION_STATUS.md                # ✅ 이 문서 (신규)
└─ README.md                               # ✅ 프로젝트 README
```

---

## 🎯 다음 단계 (Next Steps)

### 우선순위 1: 에셋 생성 (필수)
1. `ASSET_GENERATION_PROMPTS.md`의 프롬프트 사용
2. 이미지 에셋 8개 생성
3. 사운드 에셋 7개 생성
4. `assets/images/` 및 `assets/audio/`에 배치
5. `pubspec.yaml`에 에셋 등록

### 우선순위 2: 방치 수익 시스템 (권장)
1. SharedPreferences로 마지막 로그인 시간 저장
2. 복귀 시 경과 시간 계산
3. 시간당 골드/경험치 공식 설계
4. 보상 다이얼로그 UI 구현

### 우선순위 3: 스타일 이슈 수정 (선택)
1. `if` 문에 중괄호 추가
2. 불필요한 밑줄 제거
3. `withOpacity` → `withValues()` 마이그레이션

### 우선순위 4: 추가 콘텐츠 (선택)
1. 새로운 영웅 직업 추가
2. 장비 시스템 구현
3. 더 많은 스테이지 및 몬스터

---

## 🎮 현재 플레이 가능 시나리오

### 에셋 없이 현재 작동:
1. ✅ 게임 시작 → 기사 + 궁수 파티 스폰
2. ✅ 2초마다 몬스터 자동 스폰
3. ✅ 영웅들이 자동 공격
   - 궁수: 원거리 크리티컬 (빨간 글씨)
   - 기사: 근접 방어
4. ✅ 몬스터 처치 → 골드 획득 (+10)
5. ✅ 골드 50으로 영웅 레벨업
6. ✅ 10마리 처치 → 보스 스폰 (HP 5배)
7. ✅ 보스 처치 → 보너스 골드 (+50)
8. ✅ 골드 1000으로 힐러 고용
9. ✅ 힐러가 아군 자동 힐링
10. ✅ 스테이지 클리어 → 다음 스테이지 (몬스터 강화)

### 에셋 추가 후:
- 🎨 실제 픽셀 아트 캐릭터 표시
- 🔊 전투 사운드 피드백
- 🖼️ 분위기 있는 배경
- 🎵 BGM 몰입감
- ✨ 시각적 폴리쉬

---

## 🐛 알려진 이슈 (Known Issues)

### 스타일 경고 (비기능적)
- ⚠️ `curly_braces_in_flow_control_structures` - `hero_management_panel.dart:106,108`
- ⚠️ `unnecessary_underscores` - `hero_management_panel.dart:97`
- ⚠️ `deprecated_member_use` - `stage_info_overlay.dart:18` (withOpacity)

### 게임플레이 이슈
- ⚠️ 영웅 사망 시 즉시 리스폰 (임시 로직)
  - 현재: `hero.respawn()` 즉시 호출
  - 개선: 부활 타이머 또는 골드 소비 부활
- ⚠️ 방치 수익 미구현
  - 오프라인 시간 보상 없음

---

## 📊 기술 스택

- **Framework**: Flutter + Flame Engine
- **Language**: Dart
- **State Management**: ChangeNotifier
- **DI**: GetIt
- **Common Modules**: mg_common_game
  - GoldManager (경제 시스템)
  - AudioManager (사운드 시스템)
  - BaseStat (RPG 스탯 시스템)
  - FloatingTextComponent (피해량 표시)
  - GameTheme (다크 테마)

---

## 💡 핵심 기능 하이라이트

### 자동 전투 시스템
```dart
// 영웅 역할별 행동 패턴
if (hero.data.role == HeroRole.healer) {
  // 가장 HP 낮은 아군 힐
} else if (hero.data.role == HeroRole.archer) {
  // 원거리 크리티컬 공격 (range: 300)
} else {
  // 근접 전투 (range: 80)
}
```

### 보스 스폰 시스템
```dart
// 10마리 처치마다 보스 스폰
stageManager.onMonsterKilled(isBoss: false); // 카운트 증가
if (stageManager.isBossActive) {
  // 보스 스폰 (HP 5배, 보상 5배)
}
```

### 스테이지 난이도 증가
```dart
// 스테이지마다 몬스터 HP 증가
hpMultiplier: stageManager.monsterHpScale // 1.0 → 1.2 → 1.44 ...
```

---

## 🎯 완성도 로드맵

- [x] **Phase 1**: 코어 시스템 구축 (✅ 완료)
  - 영웅/몬스터 엔티티
  - 전투 로직
  - UI 패널

- [x] **Phase 2**: 게임 루프 구현 (✅ 완료)
  - 자동 전투
  - 골드 획득
  - 레벨업/고용

- [ ] **Phase 3**: 에셋 통합 (⏳ 대기)
  - 스프라이트 교체
  - 사운드 추가
  - BGM 적용

- [ ] **Phase 4**: 방치 시스템 (⏳ 대기)
  - 오프라인 보상
  - 시간 계산

- [ ] **Phase 5**: 콘텐츠 확장 (⏳ 선택)
  - 장비 시스템
  - 추가 영웅
  - 더 많은 스테이지

---

## ✅ 체크리스트 요약

- [x] 영웅 시스템 (Tank, Archer, Healer)
- [x] 몬스터 시스템 (일반, 보스)
- [x] 자동 전투 로직
- [x] 역할별 행동 패턴
- [x] UI 패널 (영웅 관리, 스테이지 정보)
- [x] 레벨업 시스템
- [x] 골드 경제
- [x] 힐러 고용
- [x] 스테이지 진행
- [x] 보스 스폰 로직
- [ ] 에셋 생성 및 통합
- [ ] 방치 수익 시스템
- [ ] 장비 시스템
- [ ] 추가 콘텐츠

**전체 진행률: 90% / 플레이 가능 상태: 90% (에셋 없이도 플레이 가능)**

---

> **Note**: 이 게임은 에셋 없이도 현재 완전히 플레이 가능한 상태입니다. 에셋 추가 시 비주얼 경험이 크게 향상됩니다.
